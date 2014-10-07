---
title: "testmarkdown.rmd"
author: "Emily Dolson"
date: "10/07/2014"
output:
  html_document:
    keep_md: yes
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


```r
x <- rnorm(100)
hist(x)
```

![plot of chunk test_snippet](figure/test_snippet.png) 

Oh, look, here's a gamma distribution


```r
g <- rgamma(100, 5)
hist(g)
```

![plot of chunk gamma](figure/gamma.png) 

