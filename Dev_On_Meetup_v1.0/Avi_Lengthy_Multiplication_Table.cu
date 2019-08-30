/*
 ============================================================================
 Name        : Avi_Lengthy_Multiplication_Table.cu
 Author      : Avimanyu Bandyopadhyay
 Email	     : avimanyu.bandyopadhyay@heritageit.edu.in
 Version     : 1.0
 Copyright   : Academic use only
 Description : CUDA Parallel Computation for Lengthy Multiplication Tables
 ============================================================================
 */



#include <iostream>
#include <ctime>
#include <cuda.h>
#include <cuda_runtime.h>	// Stops underlining of __global__ ; Also required for GPU elapsed time.

#include <device_launch_parameters.h>	// Stops underlining of threadIdx etc.

#define N (2048*2048)
#define THREADS_PER_BLOCK 512
#include <stdio.h>

// GPU kernel function to produce multiplication table of vectors 
__global__ void mult_table(unsigned long *a, unsigned long *b, unsigned long *c, unsigned long n){
	int index = threadIdx.x + blockIdx.x * blockDim.x; 
	if (index < n)
		c[index] = a[index] * b[index];
}


int main(void) {

	unsigned long *a, *b, *c; // host copies of a, b, c
	unsigned long *dev_a, *dev_b, *dev_c; // device copies of a, b, c
	unsigned long size = N * sizeof(unsigned long); // we need space for N integers
	unsigned long i, n;
	// Allocate GPU/device copies of dev_a, dev_b, dev_c
	cudaMalloc((void**)&dev_a, size);
	cudaMalloc((void**)&dev_b, size);
	cudaMalloc((void**)&dev_c, size);

	// Allocate CPU/host copies of a, b, c
	a = (unsigned long *)malloc(size);
	b = (unsigned long *)malloc(size);
	c = (unsigned long *)malloc(size);

	printf("\nParallel Computation for Lengthy Multiplication Tables:");
	printf("\n-----------------------------------------------------");
	printf("\nMaximum Index: 4194304");
	printf("\nMaximum Product Limit: 4194304");
	printf("\n\nEnter a number for table:");
	scanf("%ld", &n);
	unsigned long n2 = n;
	// Setup input values
	for (i = 0; i < N - 1; ++i)
	{
		a[i] = n;
		b[i] = i;
	}

	// Copy inputs to device
	cudaMemcpy(dev_a, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, size, cudaMemcpyHostToDevice);

	//INITIALIZE CUDA EVENTS
	cudaEvent_t start, stop;
	float elapsedTime; 

	//CREATING EVENTS
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);

	//CUDA KERNEL STUFF HERE...
	// Launch mult_table() kernel on GPU with N threads
	mult_table << <(N + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK, THREADS_PER_BLOCK >> >(dev_a, dev_b, dev_c, N);

	//FINISH RECORDING
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);

	//CALCULATE ELAPSED TIME
	cudaEventElapsedTime(&elapsedTime, start, stop);

	//DISPLAY COMPUTATION TIME WITH DEVICE NAME
	
	cudaDeviceProp prop;
	int count;

	cudaGetDeviceCount(&count);

	for (int igtx = 0; igtx < count; igtx++) {
		cudaGetDeviceProperties(&prop, igtx);
		printf("\nGPU Device used for computation: %s\n", prop.name);
		printf("\nMultiplication Table for %ld computed in: %f milliseconds", n2,elapsedTime);
	}
	//printf("The GPU '%s' computed the multiplication table for %d in %f milliseconds", prop.name, n2, elapsedTime);
	//printf("\n\nGPU Computation Time = %f ms",elapsedTime);
	
	// Copy device result back to host copy of c
	cudaMemcpy(c, dev_c, size, cudaMemcpyDeviceToHost);
	unsigned long begin, end;
		
	printf("\n\nChoose your indexes to display your required table:\n\n");

	printf("\nEnter initial index:");
	scanf("%ld", &begin);
	
	printf("\nEnter final index:");
	scanf("%ld", &end);
	printf("\n");
	for (i = begin; i <= end; ++i)
	{
		printf("%ld	X	%ld	=	%ld\n\n",n2, i, c[i]);
	}

	// Clean CPU memory allocations
	free(a); free(b); free(c);

	// Clean GPU memory allocations
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	//system("pause");
	return 0;
}

