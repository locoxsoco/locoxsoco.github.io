---
layout: page
title: 3D reconstruction of Pottery Objects
description: Bachelor's thesis Project
img: assets/img/argan/argan-preview.png
importance: 1
category: thesis
---

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/argan/argan-preview.png" title="MVCN results" class="img-fluid rounded z-depth-1" zoomable="true" %}
    </div>
</div>
<div class="caption">
    3D Reconstruction of Incomplete Archeological Objects.
</div>

## Problem

Related to the cultural heritage field, pottery reconstruction in my country (Peru) incur high costs of personnel and months of designing different preliminary models physically in order to decide the correct version. There have been plenty of solutions in order to reduce the time and costs of this process by using computational resources.

## Solution

With the increase of Deep Learning models using images, my contribution was to implement and study the performance of a GAN Deep Learning Model applied to reconstruct fractured potteries.

## Technical Steps

- **Simulate fractures:**
I used the [3D benchmark dataset](http://www.ipet.gr/~akoutsou/benchmark/) to get the original pottery models, but in order to train the Deep Learning model, I had to generate different fractured models for each pottery in order to use them as the model dataset. To achieve this task, I used the [PyMesh library](https://pymesh.readthedocs.io/en/latest/), in which with boolean operations I could remove some parts of the objects simulating the fracture of these.
<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/argan/argan-fractured-model.png" title="Original and fractured model" class="img-fluid rounded z-depth-1" zoomable="true" width="500" %}
    </div>
</div>
<div class="caption">
    Example of original and fractured model.
</div>

- **Generate multi-view depth maps:**
In this project, I wanted to study the accuracy of applying the model architectured explained in the paper [Render4Completion: Synthesizing Multi-view Depth Maps for 3D Shape Completion](https://arxiv.org/pdf/1904.08366.pdf).
<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/argan/argan-mvcn.png" title="Multi-View Completion Network" class="img-fluid rounded z-depth-1" zoomable="true" %}
    </div>
</div>
<div class="caption">
    Multi-View Completion Network workflow of the archeological objects.
</div>
By this, my task was to generate multi-view depth maps for the original and fractured models and I used the Blender API to take pictures front different points of view and obtain its depth maps. After taken the pictures, I used the Pillow library to combine the images in the specific database format.
<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/argan/argan-depthmaps.png" title="Depthmaps" class="img-fluid rounded z-depth-1" zoomable="true" width="100" %}
    </div>
</div>
<div class="caption">
    Depth maps from 8 views of the fractured and original model.
</div>

- **Implement the Deep Learning model and train:**
As the paper explains, there is one GAN model per point of view, and the model retrieves not only the reconstructed image but also a shape descriptor that others GAN models use to reconstruct the image. To achieve this task, I used the PyTorch framework to implement the architecture and a [training model monitoring system](https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix) to analyze the training which took around 2 weeks in a dedicated server in my university.
<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/argan/argan-train.png" title="Training dashboard" class="img-fluid rounded z-depth-1" zoomable="true" %}
    </div>
</div>
<div class="caption">
    Training dashboard of the MVCN.
</div>

- **Retroproject the results from Depth Maps to 3D model:**
Once the reconstructed depth maps were retrieved by the Deep Learning model, I have to retro project these into one 3D model again. For this task, I convert the Depth Map pixels into cloud points using the position of the camera points of view as their references with C/C++ using this project as the [base code](https://github.com/happylun/SketchModeling/tree/master/Fusion/src/ReconstructMesh). Then, I applied some pruning for biased pixels and finally, I used the MeshLab API to convert these point clouds into a 3D mesh object.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/argan/argan-retroproject1.png" title="Original Retroprojection" class="img-fluid rounded z-depth-1" zoomable="true" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/argan/argan-retroproject2.png" title="Recontructed Retroprojection" class="img-fluid rounded z-depth-1" zoomable="true" %}
    </div>
</div>
<div class="caption">
    Left: Retroprojection of original cloud points. Right: Retroprojection of reconstructed cloud points.
</div>

- **Compare the reconstruction with the original model and analyze the results:**
Finally, I used the Intersection over Union method to calculate the degree of similarity between the original and reconstructed models. As I chose 5 different pottery types, then I analyzed which types were easier to reconstruct and which ones were more difficult.