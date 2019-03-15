Polynomial Texture Map Fitter
Copyright Hewlett-Packard Company 2001. All rights reserved.

By using this software you indicate you have agreed to the
software license included in the license.txt file. If you do
not accept the agreement you must destroy all copies of
the software.

http://www.hpl.hp.com/ptm/

This Polynomial Texture Map (PTM) fitting program
takes a set of images from various light positions
as input and generates a PTM file as output. The
locations of the input images are specified in a
light positions file (.lp), along with the light
direction for each image.

An example .lp file is included with this executable.
The first line specifies how many input images are used.
The subsequent lines specify the location of the input
image and the x,y,z values of its light direction vector.
The supported input image formats are ppm, tga, and jpg.

The x,y,z values representing the input light direction
store the projection of the incident light direction vector
onto the camera's x,y, and z axes. The origin of the
xyz space is the center of the input images. The z axis
points perpendicular to the image plane towards the camera.
The x-axis points to the right (from the camera's point of
view), and the y-axis points up.

The fitting program currently normalizes the light vector
read from the file and uses the x and y values as the
parameters of the polynomial. The z value should be left
in the file as it affects the normalization and may be
necessary for future features in the fitting program.

If no command line options are supplied to the program
it will query the user for the input file location and
settings. Command line options can be listed by running
the program with the -h option for help. If the user
specifies any command line options but not all options
it will assume the defaults listed in the help for those
settings that have defaults.

Example usage:

PTMfitter -i c:\input\sample01\sample01.lp -o test.ptm 

Please see the paper for explanations of RGB/LRGB and
Bivariate/Univariate fitting options.

Additional software copyright notes:

The JPEG decoding section of this software is based
on the work of the Independent JPEG Group.

TGA loading code is based on tgatoppm.c. The copyright
notice for the tga loading section of the code is as follows:
   tgatoppm.c - read a TrueVision Targa file and write a portable pixmap
   Partially based on tga2rast, version 1.0, by Ian MacPhedran.
   Copyright (C) 1989 by Jef Poskanzer.
   Permission to use, copy, modify, and distribute this software and its
   documentation for any purpose and without fee is hereby granted, provided
   that the above copyright notice appear in all copies and that both that
   copyright notice and this permission notice appear in supporting
   documentation.  This software is provided "as is" without express or
   implied warranty.
This copyright notice applies only to the TGA loading code, and
does not cover the rest of the software. The source code for
the part of the program covered by this copyright is available
by request.