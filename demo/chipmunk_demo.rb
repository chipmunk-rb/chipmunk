# 
#   Copyright (c) 2010 Beoran (beoran@rubyforge.org)
#   Copyright (c) 2007 Scott Lembcke
#   
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in
#   all copies or substantial portions of the Software.
#   
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#  
# 	IMPORTANT - READ ME!
# 	
# 	This file sets up a simple interface that the individual demos can use to get
# 	a Chipmunk space running and draw what's in it. In order to keep the Chipmunk
# 	examples clean and simple, they contain no graphics code. All drawing is done
# 	by accessing the Chipmunk structures at a very low level. It is NOT
# 	recommended to write a game or application this way as it does not scale
# 	beyond simple shape drawing and is very dependent on implementation details
# 	about Chipmunk which may change with little to no warning.
#
#   XXX: UNDER CONTSRUCTION, translating it from C to ruby...
#
 
require 'chipmunk'
require 'gl'
require 'glfw'
require 'glut'

=begin
require 'demo_drawspace'
require 'demo_test'
require 'demo_logosmash'
require 'demo_simple'
require 'demo_pyramidstack'
require 'demo_plink'
require 'demo_tube'
require 'demo_pyramidtopple'
require 'demo_bounce'
require 'demo_springies'
require 'demo_pump'
require 'demo_theojansen'
require 'demo_magnetselectric'
require 'demo_unsafeops'
require 'demo_query'
require 'demo_oneway'
require 'demo_sensors'
require 'demo_joints'
=end

demos = [ 
	LogoSmash,
	Simple,
	PyramidStack,
	Plink,
	Tumble,
	PyramidTopple,
	Bounce,
	Planet,
	Springies,
	Pump,
	TheoJansen,
	MagnetsElectric,
	UnsafeOps,
	Query,
	OneWay,
	Player,
	Sensors,
	Joints,
]

demo_count      = demos.size;
curr_demo       = nil;
demo_index      = 0;
ticks           = 0;
space           = Chipmunk::Space.new
mouse_point     = Chipmunk::Vect.new(0,0)
mouse_point_last= Chipmunk::Vect.new(0,0)
mouse_body      = Chipmunk::Body.new(space)
mouse_joint     = Chipmunk::Constraint.new(space)
message_string  = ""
key_up          = false;
key_down        = false;
key_left        = false;
key_right       = false;
arrowDirection  = Chipmunk::Vec.new(0,0);
options         = { 
    :draw_hash              => false,
    :draw_bb                => false,
    :draw_shape             => false,
    :collision_point_size   => 4.0,
    :body_point_size        => 0.0,
    :line_thickness         => 1.5
}

def draw_string(x, y, str)
	glColor3f(0.0, 0.0, 0.0);
	glRasterPos2i(x, y);	
	for i in (0...str.length)
    ch     = str[i] 
    if ch == '\n'
			y -= 16;
			glRasterPos2i(x, y);
    elsif ch == '*') # print out the last demo key
      #  + demo_count - 1 FIXME!
			glutBitmapCharacter(GLUT_BITMAP_HELVETICA_10, 'A');
    else
			glutBitmapCharacter(GLUT_BITMAP_HELVETICA_10, ch);
	  end
	end
end  

def draw_instructions()
	draw_string(-300, 220,
		"Controls:\n"
		+ "A - * Switch demos. (return restarts)\n"
		+ "Use the mouse to grab objects.\n"
		+ "Arrow keys control some demos.\n"
		+ "\\ enables anti-aliasing.\n"
		+ "- toggles spatial hash visualization.\n"
		+ "= toggles bounding boxes."
	)
end

max_arbiters = 0;
max_points = 0;
max_constraints = 0;

def draw_info
	int arbiters = space->arbiters->num;
	int points = 0;
	
	for(int i=0; i<arbiters; i++)
		points += ((cpArbiter *)(space->arbiters->arr[i]))->numContacts;
	
	int constraints = (space->constraints->num + points)*(space->iterations + space->elasticIterations);
	
	max_arbiters     = [ arbiters , max_arbiters ].max;
	max_points       = [ points  , max_points].max; 
	max_constraints  = [ constraints , max_constraints].max	
	
	format = 
		"Arbiters: %d (%d) - "
		"Contact Points: %d (%d)\n"
		"Other Constraints: %d, Iterations: %d\n"
		"Constraints x Iterations: %d (%d)";
	
  buffer = sprintf(format, arbiters, max_arbiters,
		points, max_points, 
		space.constraints.size, space.iterations + space.elastic_iterations,
		constraints, max_constraints
	);
	
	drawString(0, 220, buffer);
end

static void
display(void)
{
	glClear(GL_COLOR_BUFFER_BIT);
	
	drawSpace(space, currDemo->drawOptions ? currDemo->drawOptions : &options);
	drawInstructions();
	drawInfo();
	drawString(-300, -210, messageString);
		
	glutSwapBuffers();
	ticks++;
	
	cpVect newPoint = cpvlerp(mousePoint_last, mousePoint, 0.25f);
	mouseBody->p = newPoint;
	mouseBody->v = cpvmult(cpvsub(newPoint, mousePoint_last), 60.0);
	mousePoint_last = newPoint;
	currDemo->updateFunc(ticks);
}

static char *
demoTitle(chipmunkDemo *demo)
{
	static char title[1024];
	sprintf(title, "Demo: %s", demo->name);
	
	return title;
}

static void
runDemo(chipmunkDemo *demo)
{
	if(currDemo)
		currDemo->destroyFunc();
		
	currDemo = demo;
	ticks = 0;
	mouseJoint = NULL;
	messageString[0] = '\0';
	maxArbiters = 0;
	maxPoints = 0;
	maxConstraints = 0;
	space = currDemo->initFunc();

	glutSetWindowTitle(demoTitle(currDemo));
}

static void
keyboard(unsigned char key, int x, int y)
{
	int index = key - 'a';
	
	if(0 <= index && index < demoCount){
		runDemo(demos[index]);
	} else if(key == '\r'){
		runDemo(currDemo);
	} else if(key == '-'){
		options.drawHash = !options.drawHash;
	} else if(key == '='){
		options.drawBBs = !options.drawBBs;
	} else if(key == '\\'){
		glEnable(GL_LINE_SMOOTH);
		glEnable(GL_POINT_SMOOTH);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
		glHint(GL_POINT_SMOOTH_HINT, GL_DONT_CARE);
	}
}

static cpVect
mouseToSpace(int x, int y)
{
	GLdouble model[16];
	glGetDoublev(GL_MODELVIEW_MATRIX, model);
	
	GLdouble proj[16];
	glGetDoublev(GL_PROJECTION_MATRIX, proj);
	
	GLint view[4];
	glGetIntegerv(GL_VIEWPORT, view);
	
	GLdouble mx, my, mz;
	gluUnProject(x, glutGet(GLUT_WINDOW_HEIGHT) - y, 0.0, model, proj, view, &mx, &my, &mz);
	
	return cpv(mx, my);
}

static void
mouse(int x, int y)
{
	mousePoint = mouseToSpace(x, y);
}

static void
click(int button, int state, int x, int y)
{
	if(button == GLUT_LEFT_BUTTON){
		if(state == GLUT_DOWN){
			cpVect point = mouseToSpace(x, y);
		
			cpShape *shape = cpSpacePointQueryFirst(space, point, GRABABLE_MASK_BIT, 0);
			if(shape){
				cpBody *body = shape->body;
				mouseJoint = cpPivotJointNew2(mouseBody, body, cpvzero, cpBodyWorld2Local(body, point));
				mouseJoint->maxForce = 50000.0;
				mouseJoint->biasCoef = 0.15f;
				cpSpaceAddConstraint(space, mouseJoint);
			}
		} else if(mouseJoint){
			cpSpaceRemoveConstraint(space, mouseJoint);
			cpConstraintFree(mouseJoint);
			mouseJoint = NULL;
		}
	}
}

static void
timercall(int value)
{
	glutTimerFunc(SLEEP_TICKS, timercall, 0);
		
	glutPostRedisplay();
}

static void
set_arrowDirection()
{
	int x = 0, y = 0;
	
	if(key_up) y += 1;
	if(key_down) y -= 1;
	if(key_right) x += 1;
	if(key_left) x -= 1;
	
	arrowDirection = cpv(x, y);
}

static void
arrowKeyDownFunc(int key, int x, int y)
{
	if(key == GLUT_KEY_UP) key_up = 1;
	else if(key == GLUT_KEY_DOWN) key_down = 1;
	else if(key == GLUT_KEY_LEFT) key_left = 1;
	else if(key == GLUT_KEY_RIGHT) key_right = 1;

	set_arrowDirection();
}

static void
arrowKeyUpFunc(int key, int x, int y)
{
	if(key == GLUT_KEY_UP) key_up = 0;
	else if(key == GLUT_KEY_DOWN) key_down = 0;
	else if(key == GLUT_KEY_LEFT) key_left = 0;
	else if(key == GLUT_KEY_RIGHT) key_right = 0;

	set_arrowDirection();
}

static void
idle(void)
{
	glutPostRedisplay();
}

static void
initGL(void)
{
	glClearColor(1.0f, 1.0f, 1.0f, 0.0);

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(-320.0, 320.0, -240.0, 240.0, -1.0f, 1.0f);
	glTranslatef(0.5f, 0.5f, 0.0);
	
	glEnableClientState(GL_VERTEX_ARRAY);
}

static void
glutStuff(int argc, const char *argv[])
{
	glutInit(&argc, (char**)argv);
	
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
	
	glutInitWindowSize(640, 480);
	glutCreateWindow(demoTitle(demos[firstDemoIndex]));
	
	initGL();
	
	glutDisplayFunc(display);
//	glutIdleFunc(idle);
	glutTimerFunc(SLEEP_TICKS, timercall, 0);

	glutIgnoreKeyRepeat(1);
	glutKeyboardFunc(keyboard);
	
	glutSpecialFunc(arrowKeyDownFunc);
	glutSpecialUpFunc(arrowKeyUpFunc);

	glutMotionFunc(mouse);
	glutPassiveMotionFunc(mouse);
	glutMouseFunc(click);
}

//#include <sys/time.h>
//void time_trial(char index, int count)
//{
//	currDemo = demos[index];
//	space = currDemo->initFunc();
//	
//	struct timeval start_time, end_time;
//	gettimeofday(&start_time, NULL);
//	
//	for(int i=0; i<count; i++)
//		currDemo->updateFunc(i);
//	
//	gettimeofday(&end_time, NULL);
//	long millisecs = (end_time.tv_sec - start_time.tv_sec)*1000;
//	millisecs += (end_time.tv_usec - start_time.tv_usec)/1000;
//	
//	currDemo->destroyFunc();
//	
//	printf("Time(%c) = %ldms\n", index + 'a', millisecs);
//}

int
main(int argc, const char **argv)
{
	cpInitChipmunk();
	
//	for(int i=0; i<demoCount; i++)
//		time_trial(i, 1000);
//	time_trial('d' - 'a', 10000);
//	exit(0);
	
	mouseBody = cpBodyNew(INFINITY, INFINITY);
	
	glutStuff(argc, argv);
	
	runDemo(demos[firstDemoIndex]);
	glutMainLoop();

	return 0;
}
