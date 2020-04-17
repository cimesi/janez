---
title: WiFiBot – autonomous robot for indoor areas
date: 2017-01-27T21:29:31.851Z
cover: /images/uploads/20161213_110406-1024x576.jpg
tags: []
draft: false
---
In January 2017 we made a self-driving, ROS based robot for the company Plume. It autonomously checks the WiFi coverage in indoor areas.

In September 2016 we started a project named WiFiBot in collaboration with LTFE[](http://www.ltfe.org/english/about/). We built a robot for a Slovenian company named Plume, that wants to check the quality of WiFi signal with an autonomous robot (hence the name WiFiBot) instead of having an expensive human running around.

**WiFiBot can autonomously drive on a desired path in any indoor area.** It is designed to carry a 13′ computer, that will in this case probe and check WiFi signal, but the system can be used for any number of applications.

The robot is running on ROS (Robot operating system), **uses Hector SLAM to first scan and save the map of the apartment** and AMCL package to then accurately navigate across it.

{{< youtube Dx-gcD04toE >}}
