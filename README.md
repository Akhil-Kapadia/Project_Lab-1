```
EE3331 Lab 1 Main Project Description
```
```
Hardware Delivery System
```
The Lab 1 group main project is to build an autonomous hardware delivery system mounted on
a Rover-5 tank chassis and controlled by a Basys-3 FPGA development board. The rover will follow a
metallic tape path (1 ¼ to 1 ½ in wide) and deliver hardware components to a delivery box based on
coded instruction given it on the path. The path will include at least one 90 degree turn. The path will
have 5 stations as shown in Figure 1. The first station will be on the left side of the path and will use
an infrared blinking light on the side of a 4x4 post, 4 inches off the ground to communicate to the rover
which pieces of hardware to pick up and deliver. The next 3 stations will be on the right side of the
path and will be color coded. Each will have different metal hardware (nut, bolt or washer) for the
rover to pick up. The final station will have a box on the left side of the path for the rover to deposit
the hardware. Each of the first 4 stations will have the hardware on top of a 4x4 post with the top of
the post 5 inches from the ground. Be prepared for the rover to make multiple runs around the track
with different deliver messages.

```
Figure 1. Layout for Hardware Delivery System
```
As mentioned, Station 1 will communicate to the rover which pieces of hardware to pick up and
deliver. It will use different IR frequencies to communicate this. The following is a breakdown of the
delivery messages:

```
200 Hz – Pick up from Red and Blue stations
1 kHz  – Pick up from Red and Green stations
5 kHz  – Pick up from Blue and Green stations
30 kHz - Stop Running
```



