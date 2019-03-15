# HSHFitter Wine

# Usage

Once started, the Docker container will process all RTI capture sessions automatically.
This requires structuring image files and light vector files correctly, and mounting a docker volume.

## TL;DR;

```shell
docker run --rm -v $(pwd)/data/:/app/data sepastian/hshfitter_wine
```

## Placing Image Files and Light Vectors

This section describes how to structure image files and light position vectors, for processing by the Docker container.

Image files must be in JPG format, the file extension must be `jpg`, e.g. `0001.jpg`.
The example that follows assumes that each capture session creates 64 JPG images named `0001.jpg`, `0002.jpg` through `0064.jpg`.

```
data
  |- capture_001
  |    |- lights.lp
  |    |- 0001.jpg
  |    |- 0002.jpg
  |    |  :
  |    '- 0064.jpg
  '- capture_002
       |- lights.lp
       |- 0001.jpg
       |- 0002.jpg
       |  :
       '- 0064.jpg
```

Structure all image files an light vector files as shown above;
inside a data directory (`data`), create one folder per capture session (`capture_001`, `capture_002`, and so on);
place `lights.lp` inside each capture folder;
place all images stemming from a capture session inside the capture folder.

Following is a sample light vector file `lights.lp` describing 3 light vectors.
The example above would require a light vector file containing 64 entries.
Each row describes a single light vector by three floats from the range `(-1,1)`,
the floats are separated by a single blank space.
No comments or other information is allowed inside `lights.lp`.

```
0.49750078 -0.85780865 0.12906335
0.95672685 -0.25136346 0.14659522
0.8540631 0.49735278 0.1523693
```

Given a directory containing JPG files, each image will be assigned to a light vector as follows:
  - sort the images alphabetically
  - assign the first image to the first light vector in row one in `lights.lp`
  - assign image two to the second light vector, and so on.

The number of image files and the number of light vectors described in `lights.lp` must match.
Although not required, it is recommended to name the images files `NNNN.jpg`, where `NNNN` is a zero-padded integer, to guarantee correct sorting order.

## Starting the Container

Assuming that the images and light position vectors have been placed in a data folder as described above,
start the container mounting the data folder as a Docker volume at `/app/data` inside the container.

```shell
docker run --rm -v $(pwd)/app/data/:/app/data sepastian/hshfitter_wine
```

For each `lights.lp` file found in `/app/data` inside the container, an RTI image will be processed.

If an RTI file to create exists already, that file will be skipped, i.e. no existing files will be overwritten.

# Software

## HSH Fitter

HSHfitter by CHI packaged into a Docker image.

Contains Software downloaded from CHI's website http://culturalheritageimaging.org/What_We_Offer/Downloads/Process/, which has been released under GPL3.

## PTM Fitter

PTM Fitter is no longer available on HP Labs site: http://www.hpl.hp.com/research/ptm/downloads/download.html

A cached version has been downloaded from the Internet Archive on 2019-03-15: http://web.archive.org/web/20180815062110/http://www.hpl.hp.com/research/ptm/downloads/download.html

The Linux version of PT Fitter requires a 32 bit OS, which is incompatible with Docker. Thus, the Windows version has been packaged instead.
