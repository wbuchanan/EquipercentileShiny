---
title: "Equipercentile Scale Linking"
author: "W. R. Buchanan - Strategic Data Fellow at MDE & Adjunct Professor of Education at Jackson State University"
date: "September 19, 2014"
output: html_document
runtime: shiny
---

# About the Application
This application was developed to give you an opportunity to **see** how equipercentile linking works, rather than just hearing the same information repeatedly.  I've tried to keep the jargon to a minimum as much as possible, but in this context *some jargon is unavoidable*.  I've provided instructions below and hope you'll find this to be a useful tool for illustrating this technique for scale linking.

# What is Equating/Linking any way?
Equating and linking are recipes used to take the values on one scale and map them on to another one.  It's like when you took the SAT/ACT.  There are dozens of test forms, with different questions being used simultaneously and in order to make sense out of all of that chaos the psychometricians (these are the number geeky types in the testing world) use equating and linking techniques so that you only have a single scale (200-800 for all SAT, and 1-36 for all ACT) to think about at the end of the day.

## A caveat before we begin
*The one caveat that I want to mention up front is that R does not have a parallel version of the percentile formula used by Stata that is implemented the same way.*  In other words, this is meant as an example and teaching tool to explain the concepts of the process.  If you wanted to read more specifically about the methodology used by Stata, feel free to click on the link [here](http://www.stata.com/manuals13/dpctile.pdf) to view the manual entry for that procedure; if all that you want is the specific algorithm and are familiar with \sigma notation you will be fine.

## About that process...
If you are an [R](http://cran.r-project.org) user, then you can view the code that I used to build this application [on Github](https://github.com/wbuchanan/EquipercentileShiny).  But the story begins with two groups that exist on different scales: schools withouth 12th grade and with science and schools without 12th grade and without science.  Like many of you know, it would be absurd to put both groups on the same scale, since schools that do not offer 5th or 8th grade would perpetually be at a 100 point disadvantage.  So, we use the linking process to select scores that reflect the progress, effort, and success of the schools that do not have a 12th grade and do have science.  Now that we understand where things are coming from, lets start walking through the process used here:

1. Calculate percentiles for schools within their respective groups (with vs without science)
2. Apply the cut scores for the 700 point scale to schools with science only
3. Find the highest and lowest percentiles for each letter grade for schools with science
    * This part can be a bit confusing, but the third step is really where the "link" is created.
4. Use the high/low **percentiles from schools with science** to find the high/low *points with the same percentile value for schools without science*.
    * In other words, if the schools with science that earned an A were in the 92-99th percentiles, the cutscores for schools without science would be based on the total points for schools without science that were also in the 92-99th percentiles
5. Once all of the cut scores are known, then grades can be assigned accordingly

# Conclusion
Again, my hope is that you'll be able to use the application below to play with some live data and see how things compare to one another visually and in terms of the data itself.  If you wanted to try replicating things on your own, you can download the data that you generate each time you click on the **Create My Graphs!** button by clicking on the tab labeled "Get the Data", scrolling to the bottom, and clicking on *Download the Data.*



