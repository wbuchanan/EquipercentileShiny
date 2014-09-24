---
title: "Equipercentile Scale Linking"
author: "W. R. Buchanan - Strategic Data Fellow at MDE & Adjunct Professor of Education at Jackson State University"
date: "September 24, 2014"
output: html_document
runtime: shiny
---

# About the Application
This application was developed to give you an opportunity to **see** how equipercentile linking works, rather than just hearing the same information repeatedly.  I've tried to keep the jargon to a minimum as much as possible, but in this context *some jargon is unavoidable*.  I've provided instructions below and hope you'll find this to be a useful tool for illustrating this technique for scale linking.

# What is Equating/Linking any way?
Equating and linking are recipes used to take the values on one scale and map them on to another one.  It's like when you took the SAT/ACT.  There are dozens of test forms, with different questions being used simultaneously and in order to make sense out of all of that chaos the psychometricians (these are the number geeky types in the testing world) use equating and linking techniques so that you only have a single scale (200-800 for all SAT, and 1-36 for all ACT) to think about at the end of the day.

## A caveat before we begin
*The one caveat that I want to mention up front is that R does not have a parallel version of the percentile formula used by Stata that is implemented the same way.*  In other words, this is meant as an example and teaching tool to explain the concepts of the process.  If you wanted to read more specifically about the methodology used by Stata, feel free to click on the link [here](http://www.stata.com/manuals13/dpctile.pdf) to view the manual entry for that procedure.

## About that process...
If you are an [R](http://cran.r-project.org) user, then you can view the code that I used to build this application [on Github](https://github.com/wbuchanan/EquipercentileShiny).  But the story begins with two groups that exist on different scales: schools withouth 12th grade and with science and schools without 12th grade and without science.  Like many of you know, it would be absurd to put both groups on the same scale, since schools that do not offer 5th or 8th grade would perpetually be at a 100 point disadvantage.  So, we use the linking process to select scores that reflect the progress, effort, and success of the schools that do not have a 12th grade and do have science.  Now that we understand where things are coming from, lets start walking through the process used here:

1. Split schools w/o a 12th grade into two groups: schools w/science and schools w/o science 
2. Calculate the percentiles of the total points for the schools listed above that have science
3. Repeat the step above for the schools that do not have science
4. Assign letter grades to schools that have science using the cut scores published in the [business rules](https://districtaccess.mde.k12.ms.us/Accountability/Public%20Documents/MSAS%20Business%20Rules%20-%20Revised%20May%202014.pdf)
5. Find the lowest and highest percentile score for each performance classifier (e.g., the lowest and highest percentiles for A, B, C, D, and F schools) for schools with science
6. Use the percentile values above to determine the comparable total points for schools w/o science

# Conclusion
Again, my hope is that you'll be able to use the application below to play with some live data and see how things compare to one another visually and in terms of the data itself.  If you wanted to try replicating things on your own, you can download the data that you generate each time you click on the **Create My Graphs!** button by clicking on the tab labeled "Get the Data", scrolling to the bottom, and clicking on *Download the Data.*



