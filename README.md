# LEDandPushButtons

The objective of this lab is to continue learning and practicing programming structures in assembly. The lab requires the interface with external hardware using a push button and LED. The software Multisim was used for drawing and analyzing electrical circuits. This lab also aims to continue and expand on knowledge of wiring electrical components, the use of a digital multimeter, and creating circuit configurations along with the microcontroller. 

## Background

First, the ports 4 and 5 were defined using the GPIO offset addresses. Once in main, Port 5 and Port 4 are initialized. Port 5 is initialized by setting the P5SEL0 and P5SEL1 to 0 in order to use it as I/O. The direction of Port 5 Pin 0 is set as 0 meaning it will be used as an input. The pull up resistors on Port 5 Pin 0 are not needed so they are commented out. Next, Port 4 is initialized by setting P4SEL0 and P4SEL1 as 0 in order to use it as I/O. The direction of Port 4 Pint 0 is set as 1 because it will be used as an output. Port 4 Pin 0 (LED) is set as 1 meaning the LED is initially ON. 
    Next, the program branches to the loop and moves Hexadecimal values to register 7 and register 8, respectively. This will be used to manage the timing and toggling of the LED at about 62.5ms. Following, the input is read from Port 5 Pin 0 to check whether or not the push button is pressed. This is checked by “ANDing” the input from Port 5 Pin 0 with Hexadecimal 1 and storing the result in register 0. Then, the result is compared with 01 and 00. If register 0 is equal to 01, the push button is pressed and a branch to the subroutine swpressed occurs, if register 0 is equal to 00, the push button isn’t pressed and a branch to the subroutine nopressed occurs. In the swpressed subroutine, register 0 is set to 1, there’s a branch to Port4_Output subroutine where the LED is set to turn and stay ON. In the nopressed subroutine, register 0 is set to 0, there’s a branch to Port4_Output subroutine where the LED is turned OFF and then returns to the nopressed subroutine. This is repeated X amount of times using register 7 in order to create the delay and toggle of the LED between ON and OFF. 

