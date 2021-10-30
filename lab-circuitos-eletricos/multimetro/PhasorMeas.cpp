#include "mbed.h"
#define PFACTOR 65535
Ticker tick;
bool aux = 0;
AnalogIn a1(PTB1);
AnalogIn a0(PTB0);
float Ts = 2.0/3500;
Serial pc(USBTX, USBRX);

// Interrupt
void interrupt()
{
    aux = 1;
}

float tension1(float v)
{
    return (19.97/2.77)*v;
}

float tension0(float v)
{
    return (13.55/1.85)*v;
}

bool isGreaterThanAverage(float v, float average) {
    if (v > average) {
        return 1;
    }
    return 0;
}

float normalize(int v) {
    return 3.3*v/((float)PFACTOR);
}

float calculateAverage(float v[10]) {
    float sum = 0;
    for (int i = 0; i < 10; i++) {
        sum += v[i];
    }
    return sum*0.1;
}

float frequency (uint16_t* v, int data_size, float Ts, float *phase) {
    bool b1, b2 = 0;
    float t0 = 0;
    float tf = 0;
    float cycles = 0;
    double average = 0;
    for (int i = 0; i < data_size; i++) {
        average += v[i];
    }
    average = average/data_size;
    
    for (int i = 0; i < data_size - 1; i++) {
        double v1 = v[i];
        double v2 = v[i+1];
        b1 = isGreaterThanAverage(v1, average);
        b2 = isGreaterThanAverage(v2, average);
        if (!b1 and b2) {
            if (t0 == 0) {
                t0 = i*Ts;
            }
            else {
                tf = i*Ts;
                cycles += 1;
            }
        }
    }
    float period = ((tf - t0))/cycles;
    *phase = t0*360/period;
    return 1/period;
}

float phase (uint16_t* v, int data_size, float Ts, float period) {
    float phase = 0;
    bool b1, b2 = 0;
    float t0 = 0;
    float tf = 0;
    float cycles = 0;
    double average = 0;
    for (int i = 0; i < data_size; i++) {
        average += v[i];
    }
    average = average/data_size;
    
    for (int i = 0; i < data_size - 1; i++) {
        double v1 = v[i];
        double v2 = v[i+1];
        b1 = isGreaterThanAverage(v1, average);
        b2 = isGreaterThanAverage(v2, average);
        if (!b1 and b2) {
            if (t0 == 0) {
                t0 = i*Ts;
            }
            else {
                tf = i*Ts;
                phase += tf - cycles*period;
                cycles += 1;
            }
        }
    }
    phase = phase/cycles;
    phase = phase*360/period;
    return phase;
}


int phasorView()
{
    float Ts = 1.0/10000;
    int data_size = 0.2/Ts; // quantidade de medições de tensão
    uint16_t data_v1[data_size]; //unsigned int since input > 0
    uint16_t data_v0[data_size]; // vetor de medições de tensão do segundo circuito
    float ten_average1[10], ten_average0[10];
    float ten_tension1[10], ten_tension0[10];
    float ten_f1[10], ten_f0[10];
    float ten_phase[10];
    int count = 0;
    

    pc.printf("START \r\n");

    while (1) {
        float average1 = 0; // tensão média
        float average0 = 0;
        float v_eff1 = 0; // valor eficaz quadratico do primeiro circuito
        float v_eff0 = 0; // valor eficaz quadratico do segundo circuito
        float offset1 = 1.61; // offset do primeiro circuito
        float offset0 = 1.61; // offset do segundo circuito
        float voltage = 0;
        int n = 0; // iterador do loop de medições

        tick.attach(&interrupt, Ts);
        do {
            if (aux == 1) {
                aux = 0;
                // 1st circuit measure
                data_v1[n] = a1.read_u16();
                // 2nd circuit measure
                data_v0[n] = a0.read_u16();

                n += 1;
            }
        } while (n != data_size);

        // 1st circuit average
        for (int i=0; i < data_size; i++) {
            voltage = 3.3*((float) data_v1[i]/PFACTOR);
            average1 += (voltage - offset1)/data_size;
            v_eff1+= (voltage - offset1)*(voltage - offset1)/data_size;
        }

        // 2nd circuit average
        for (int i=0; i < data_size; i++) {
            voltage = 3.3*((float) data_v0[i]/PFACTOR);
            average0 += (voltage - offset0)/data_size;
            v_eff0 += (voltage - offset0)*(voltage - offset0)/data_size;
        }
                
        // calcular aqui a fase com base nos vetores v_eff1 e v_eff2
        float phase1, phase0;
        float f0 = frequency(data_v0, data_size, Ts, &phase0);
        float f1 = frequency(data_v1, data_size, Ts, &phase1);
        phase0 = phase1 = 0;
        phase0 = phase(data_v0, data_size, Ts, 1/f0);
        phase1 = phase(data_v1, data_size, Ts, 1/f1);

        float phase = phase1 - phase0;
        if (phase < -180) {
            phase += 360;
        }
        if (phase > 180) {
            phase -= 360;
        }
        
        ten_average1[count] = average1;
        ten_average0[count] = average0;
        ten_tension1[count] = tension1(sqrt(v_eff1));
        ten_tension0[count] = tension0(sqrt(v_eff0));
        ten_f1[count] = f1;
        ten_f0[count] = f0;
        ten_phase[count] = phase;
        count += 1;
        
        
        if (count == 10) {
            count = 0;
            average1 = calculateAverage(ten_average1);
            average0 = calculateAverage(ten_average0);
            float t1 = calculateAverage(ten_tension1);
            float t0 = calculateAverage(ten_tension0);
            f1 = calculateAverage(ten_f1);
            f0 = calculateAverage(ten_f0);
            phase = calculateAverage(ten_phase);
            pc.printf("C1 (polar) : (%f V, %f graus)) \r\n", t1*sqrt(2), phase);
            pc.printf("C1 (cartesiano): %f(%f, %f) V\r\n", t1*srqt(2), cos(phase), sin(phase));
        }
    }
}
