/*
The hardware-engineering group has graciously provided the following C header file for the hardware
interface library. All functions do the obvious function implied by their name. It is worth noting that the
GetBrewButtonStatus function will only return the "pushed" status once for each push of the button
(this avoids problems with the user leaning on the button and sending many "pushed" messages).
*/

/* Coffee Maker Low Level Hardware Interface */
enum WarmerPlateStatus { potNotEmpty, potEmpty, warmerEmpty };
enum WarmerPlateStatus GetWarmerPlateStatus ();
enum BoilerStatus { boilerEmpty, boilerNotEmpty };
enum BoilerStatus GetBoilerStatus ();
enum BrewButtonStatus { brewButtonPushed, brewButtonNotPushed };
enum BrewButtonStatus GetBrewButtonStatus ();
enum BoilerState { boilerOn, boilerOff };
void SetBoilerState (enum BoilerHeaterState s);
enum WarmerState { warmerOn, warmerOff };
void SetWarmerState (enum WarmerState s);
enum IndicatorState { indicatorOn, indicatorOff };
void SetIndicatorState (enum IndicatorState s);
