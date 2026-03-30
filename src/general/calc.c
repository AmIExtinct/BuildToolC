#include "general/calc.h"
#include <stdio.h>

void createTable(float tableOf, int tableUpto){
   for (int x = 1; x<=tableUpto; x++) {
     printf("%f X %0.f = %f", tableOf, (float)x, tableOf*(float)x);
   }

   printf("-_-\n");
}
