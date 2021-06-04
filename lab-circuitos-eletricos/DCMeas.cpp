#include "mbed.h"
#include "TSISensor.h"

Ticker tick;
bool aux = 0;
float Ts = 1.0/2000;
AnalogIn a(PTB0);
Serial pc(USBTX, USBRX);

// Interrupt
void interrupt()
{
    aux = 1;
}

float tension(float v) {
    int r1 = 332;
    int r2 = 675.4;
    
    return ((float) (r1 + r2)/r1)*v;
}

float current(float v) {
    float r = 1.3;
    
    return ((float) 1/r)*v;
}


void tensionDCView()
{  
    //Sensor
    TSISensor tsi;
    int window; //inverse Kp or Ki
    int i = 0;
    int windows[10] = {1000, 500, 100, 50, 20, 10, 8, 6, 5, 4};
    window = windows[0];
    
    while (1) {
        // Sensor
        if (tsi.readPercentage()) {      
            i = (i + 1)%10;
            window = windows[i];
            wait(1.5);
        }
        
        //Multimeter
        int n = 0;
        int data_size = window;
        float offset = 0; //ALTERAR PARA VALOR DO PROJETO!!!
        double average = 0;
        double v_eff2 = 0;


        tick.attach(&interrupt, Ts);
        while(1) {
            if (aux == 1) {
                aux = 0;

                float b = a.read();

                n += 1;

                average = (average*(n-1) + 3.3*b)/n;
                v_eff2 = (v_eff2*(n-1) + (3.3*b - offset)*(3.3*b - offset))/n;

            }
            if (n == data_size) {
                break;
            }
        }
        pc.printf("v medio: %f janela: %d\r\n", tension(average), window);
    }
}

void currentDCView()
{  
    while (1) {        
        //Multimeter
        int n = 0;
        int data_size = 1000;
        float offset = 0; 
        double average = 0;
        double v_eff2 = 0;

        tick.attach(&interrupt, Ts);
        while(1) {
            if (aux == 1) {
                aux = 0;

                float b = a.read();
                n += 1;

                average = (average*(n-1) + 3.3*b)/n;
                v_eff2 = (v_eff2*(n-1) + (3.3*b - offset)*(3.3*b - offset))/n;

            }
            if (n == data_size) {
                break;
            }
        }
        pc.printf("i medio: %f mA\r\n", 1000*current(average));
    }
}

