#include "general/calc.h"
#include <stdio.h>

void createTable(float *tableOf, int *tableUpto){
   
   for (int x = 1; x<=*tableUpto; x++) {
     printf("\t\t %f  X  %0.f \t=\t %f \n\n", *tableOf, (float)x, *tableOf*(float)x);
   }

   printf("-_-\n");
}
