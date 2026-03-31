#include <stdio.h>
#include "general/calc.h"

int doLameIntro();

int main(void){
   printf("Hola Goobers\n");
  
   if (doLameIntro() == 1) {
     float tableOf;
     int tableUpto;

     printf(" Table Of: ");
     scanf("%f", &tableOf);

     printf("\n Table Upto: ");
     scanf("%d", &tableUpto);
      
     createTable(tableOf, tableUpto);
   }

   return 0;
}


int doLameIntro(){
   char c;
   printf("Wanna See Something Cool? (Y or N?)\n");
   printf("> ");
   scanf("%c", &c);

   if (c == 'Y' || c == 'y') {
     printf("Mhm....Good Choice\n");
     return 1;

   }
   else if (c == 'n' || c == 'N') {
      printf("Yeah Cool Whatever :(\n");
      return 0;
   }
   else {
      printf("\nWhatchu Talking About?\n");
   }
   return 0;
}
