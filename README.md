# FAST-9 Accelerator
FAST-9 Algorithm for Corner Detection

- Software

> The C++ code used OpenCV. <br>
> Visual Studio projects are intended to be tested in software before being implemented in hardware. <br>

- Hardware

> The Verilog code is hardware that detects corners in an image of 180x120 size for real-time image processing. <br>
> One pixel operates for about 20 clocks to detect corners. <br>
> The FAST-9 algorithm 3 stage was designed as a pipeline. <br>

Design
----------
![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/BlockDiagram/Feature_Detection.png)
![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/BlockDiagram/Feature_Score.png)
![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/BlockDiagram/Non-Maximal_Supression.png)
<br>

Example
----------
![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/h.png)
![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/h-fast9.png)

![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/stop.png)
![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/stop-fast9.png)

![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/camera.png)
![Alt Text](https://github.com/ISKU/FAST9-Accelerator/blob/master/Sample/camera-fast9.png)
<br>

:bulb: I applied the FAST-9 algorithm to this project: [Autonomous-Drone-Design](https://github.com/ISKU/Autonomous-Drone-Design)

Author
----------
> - Minho Kim ([ISKU](https://github.com/ISKU))
> - **E-mail:** minho.kim093@gmail.com
