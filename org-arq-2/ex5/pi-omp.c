#include <stdio.h>
#include <omp.h>

int main() {

    int i;
    double x, sum, aux, step, pi;

    // Use 200 million steps
    long num_steps = 200000000;

    x=0;
    sum = 0.0;
    step = 1.0/(double) num_steps;
#pragma omp parallel private(i,x,aux) shared(sum) 
   {
#pragma omp for schedule(static) 
      for (i=0; i<num_steps; i=i+1){
         x=(i+0.5)*step;
         aux=4.0/(1.0+x*x);
#pragma omp critical
         sum = sum + aux;
      }
      int thread_ID = omp_get_thread_num();
      printf(" pi %d\n", thread_ID);
   }
   pi=step*sum;
   printf(" pi: %.5f\n", pi);
}

