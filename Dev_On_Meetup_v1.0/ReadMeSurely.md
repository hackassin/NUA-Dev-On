The following programs were executed on NUA Dev On Meetup v1.0,to showcase the power of GPU computing. 
Please note:
1. We have used CudaMemCpy, to copy the host and device variables. 
2. The above step won't be necessary in Jetson Nano,since it's a Tegra based chip.
3. In Nvidia Tegra devices, both CPU & GPU share the same memory.
4. Hence, there's a 'ZeroCopy' feature available to skip CudaMemCpy procedure,inorder to save computation and compilation time. 
