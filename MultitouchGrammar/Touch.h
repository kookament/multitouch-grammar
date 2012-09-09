#import <Foundation/Foundation.h>
#include <unistd.h>
#include <CoreFoundation/CoreFoundation.h>

typedef struct {
	float x, y;
} mtPoint;

typedef struct {
	mtPoint position, velocity;
} mtVector;

typedef struct {
	int frame;           // Current event frame.
	double timestamp;    // Touch event timestamp.
	int identifier;      // ID of this touch in the current gesture, on [1,11].
	int state;           // Current state; exact meaning of values unknown.
	int unknown1;        // ?
	int unknown2;        // ?
	mtVector normalized; // Normalized position/velocity of touch.
	float size;          // Area of the touch being tracked.
	int unknown3;        // ?
	float angle;         // Angle of the touch.
	float majorAxis;     // Major axis of the touch ellipsoid.
	float minorAxis;     // Minor axis of the touch ellipsoid.
	mtVector unknown4;   // ?
	int unknown5[2];     // ?
	float unknown6;      // ?
} Touch;

typedef void *MTDeviceRef;                                               // Reference pointer for multitouch device.
typedef int (*MTContactCallbackFunction)(int, Touch*, int, double, int); // Prototype for callback function.

MTDeviceRef MTDeviceCreateDefault();                                         // Returns a pointer to the default device (trackpad).
CFMutableArrayRef MTDeviceCreateList(void);                                  // Returns a CFMutableArrayRef array of all multitouch devices.
void MTRegisterContactFrameCallback(MTDeviceRef, MTContactCallbackFunction); // Registers a device's frame callback to a callback function.
void MTDeviceStart(MTDeviceRef, int);                                        // Start sending events.