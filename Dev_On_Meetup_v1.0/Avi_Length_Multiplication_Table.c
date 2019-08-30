/*
 ============================================================================================================================================================
 Name        : Avi_Lengthy_Multiplication_Table.c
 Author      : Avimanyu Bandyopadhyay
 Email	     : avimanyu.bandyopadhyay@heritageit.edu.in
 Version     : 1.0
 Copyright   : Academic use only
 Description : C program to find multiplication table up to 1200000(To be accompanied with its parallel CUDA C version - Avi_Lengthy_Multiplication_Table.cu)
 ============================================================================================================================================================
 */

/* C program to find multiplication table up to 1200000*/
#include <stdio.h>
#include <time.h>
int main()
{

    int n;
    long int i,x;

    printf("Enter an integer to find multiplication table: ");
    scanf("%d",&n);

    printf("\nEnter the limit:");
    scanf("%ld",&x);
 
    clock_t begin = clock();
    for(i=1;i<=x;i++)
    {
		printf("%d * %ld = %ld\n", n, i, n*i);
    }
    
    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;

    printf("\nExecution time = %fs\n",time_spent);
    //system("pause");
    return 0;
}
