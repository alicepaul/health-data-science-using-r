# Intro to Exploratory Data Analysis

In the last chapter, we learned about loading data into R and practiced selecting and summarizing columns and rows of the data. In this chapter, we will learn how to conduct more exploratory analysis focusing on the univariate and bivariate sample distributions. The first half focuses on using base R to create basic plots and summaries. In the second half, we show how to utilize create summary plots using the `GGally` package and tables using the `gt` and `gtsummary` packages.


```R
library(RforHDSdata) # sample data
library(GGally) # pairwise plots
library(gt) # tables
library(gtsummary) # summary tables
```

## Univariate Distributions

We will use a samples of the National Health and Nutrition Examination Survey ([NHANES](https://www.cdc.gov/nchs/nhanes/index.htm)). The sample contains lead, blood pressure, BMI, smoking status, alcohol use, and demographic variables from NHANES 1999-2018, downloaded from the nhanesA package. There are 31,625 observations in this sample. Use the help operator `?NHANESsample` to read the variable descriptions.


```R
data(NHANESsample)
dim(NHANESsample)
names(NHANESsample)
```


<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>31265</li><li>15</li></ol>




<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>'id'</li><li>'age'</li><li>'sex'</li><li>'race'</li><li>'education'</li><li>'income'</li><li>'smoke'</li><li>'year'</li><li>'lead'</li><li>'bmi_cat'</li><li>'dbp'</li><li>'lead_quantile'</li><li>'sbp'</li><li>'hyp'</li><li>'alc'</li></ol>



To start our exploration, we will look at whether there are any missing values. We use the `complete.cases()` function to observe that there are 30,405 complete cases. We also see that alcohol use has the highest percentage of missing values. For demonstration, we chose to do a complete case analysis using the `na.omit()` function to define our complete data frame `nhanes_df`. 


```R
sum(complete.cases(NHANESsample))
apply(NHANESsample, 2, function(x) sum(is.na(x)))/nrow(NHANESsample)
```


30405



<style>
.dl-inline {width: auto; margin:0; padding: 0}
.dl-inline>dt, .dl-inline>dd {float: none; width: auto; display: inline-block}
.dl-inline>dt::after {content: ":\0020"; padding-right: .5ex}
.dl-inline>dt:not(:first-of-type) {padding-left: .5ex}
</style><dl class=dl-inline><dt>id</dt><dd>0</dd><dt>age</dt><dd>0</dd><dt>sex</dt><dd>0</dd><dt>race</dt><dd>0</dd><dt>education</dt><dd>0.000671677594754518</dd><dt>income</dt><dd>0</dd><dt>smoke</dt><dd>0</dd><dt>year</dt><dd>0</dd><dt>lead</dt><dd>0</dd><dt>bmi_cat</dt><dd>0</dd><dt>dbp</dt><dd>0</dd><dt>lead_quantile</dt><dd>0</dd><dt>sbp</dt><dd>0</dd><dt>hyp</dt><dd>0</dd><dt>alc</dt><dd>0.0268671037901807</dd></dl>




```R
nhanes_df <- na.omit(NHANESsample)
```

In the last chapter, we introduced the `table()` and `summary()` functions to quickly summarize categorical and quantitative vectors. 


```R
table(nhanes_df$smoke)
summary(nhanes_df$year)
```


    
    NeverSmoke  QuitSmoke StillSmoke 
         14671       8559       7175 



       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
       1999    2003    2007    2007    2011    2017 


We decide to select the most recent observations for our analysis in this chapter. We use the `subset()` function to select these rows. 


```R
nhanes_df <- subset(nhanes_df, nhanes_df$year==2017)
```

As shown above, smoking status has been coded into three categories. We want to create a new variable to represent whether someone has ever smoked. To do so, we use the `ifelse()` function. This function allows us to create a new vector using some logic. The logic captured by this function is that we will take one value if we meet some condition(s) and we will use a second value otherwise. The first argument is a vector of TRUE/FALSE values representing the conditions, the next argument is the value to use if we meet the condition(s), and the last argument is the value to use otherwise. We use this function to create a new vector `ever_smoke` that equals "Yes" for those who are either still smoking or quit smoking and "No" otherwise. 


```R
nhanes_df$ever_smoke <- ifelse(nhanes_df$smoke %in% c("QuitSmoke", "StillSmoke"), "Yes", "No")
table(nhanes_df$ever_smoke)
```


    
      No  Yes 
    1514 1249 


The `summary()` and `table()` functions allow us to summarize the univariate sample distributions of columns. We may also want to plot these distributions. We saw in the last chapter that the `hist()` function creates a histogram plot. Below we use this to plot a histogram of the log transformation of the lead column.


```R
hist(log(nhanes_df$lead))
```


    
![png](output_14_0.png)
    


If we want to polish this figure, we can use some of the other optional arguments to the function (see `?hist` for the full list of arguments). For example, we may want to update the text `log(nhanes_df$lead)` in the title and x-axis. Below we update the [color](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf), labels, and number of bins for the plot. The argument `breaks` specifies the number of bins to use to create the histogram, `col` specifies the color, `main` specified the title of the plot, and `xlab` specifies the x-axis label (using `ylab` would specify the y-axis label). 


```R
hist(log(nhanes_df$lead), breaks = 30, col="blue", main="Histogram of Log Blood Lead Level",
    xlab="Log Blood Lead Level")
```


    
![png](output_16_0.png)
    


For categorical variables, we may want to plot the counts in each category using a bar plot. The function `barplot()` asks us to specify the `names` and `heights` of the bars. To do so, we will need to store the counts for each category. Again, we update the color and labels.


```R
smoke_counts <- table(nhanes_df$smoke)
barplot(height=smoke_counts, names=names(smoke_counts), col="violetred",
       xlab="Smoking Status", ylab="Frequency")
```


    
![png](output_18_0.png)
    


With a bar plot, we can even specify a different color for each bar. To do so, `col` must be a vector of specified colors with the same length as the number of categories.


```R
barplot(height=smoke_counts, names=names(smoke_counts), col=c("orange","violetred","blue"),
       xlab="Smoking Status", ylab="Frequency")
```


    
![png](output_20_0.png)
    


### Practice Question

## Bivariate Distributions

We now turn our attention to the relationship between multiple columns. When we have two categorical variables, we can use the `table()` function to find the counts across all combinations. Below, we look at the distribution in smoking status by sex. We observe that a higer percentage of female participants have never smoked. 


```R
table(nhanes_df$smoke, nhanes_df$sex)
```


                
                 Male Female
      NeverSmoke  629    885
      QuitSmoke   423    257
      StillSmoke  341    228


To look at the sample distribution of a continuous variable stratified by a cateogrical variable, we could call the `summary()` function for each subset of the data. Below we look at the distribution of blood lead level by sex. 


```R
summary(nhanes_df$lead[nhanes_df$sex=="Female"])
summary(nhanes_df$lead[nhanes_df$sex=="Male"])
```


       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
       84.0   108.0   118.0   122.5   132.0   218.0 



       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
       80.0   116.0   124.0   126.8   136.0   232.0 


We could also observe this visually through a box plot. When given one categorical variable and one continuous variable, the `plot()` function creates a box plot. By default, the first argument is the x-axis variable and second argument is the y-axis variable. 


```R
plot(nhanes_df$sex, log(nhanes_df$lead), ylab="Log Blood Lead Level", xlab="Sex")
```


    
![png](output_27_0.png)
    


Alternatively, we could use the `boxplot()` which can be passed a formula to specify how to group the data. In the case below, we group by multiple columns, `sex` and `ever_smoke`, so our formula is `lead~sex+ever_smoke`. The second argument to the function specifies the data.  We specify the column colors to show the link between the box plots shown. 


```R
boxplot(log(lead)~sex+ever_smoke, data=nhanes_df, col=c("orange", "blue", "orange", "blue"),
       xlab="Sex : Ever Smoked", ylab = "Log Blood Lead Level")
```


    
![png](output_29_0.png)
    


To visualize the bivariate distribution between two continuous variables, we can use a scatter plot. To create a scatter plot, we use the `plot()` function again. We use this function to show the relationship between systolic and diastolic blood pressure. 


```R
plot(nhanes_df$sbp, nhanes_df$dbp, col="blue", xlab="Systolic Blood Pressure",
    ylab="Diastolic Blood Pressure")
```


    
![png](output_31_0.png)
    


The two measures of blood pressure look highly correlated. We can calculate their Pearson and Spearman correlation using the `cor()` function. The default method is the Pearson correlation, but we can also specify to calculate the Kendall or Spearman correlation by specifying the method. 


```R
cor(nhanes_df$sbp, nhanes_df$dbp)
cor(nhanes_df$sbp, nhanes_df$dbp, method="spearman")
```


0.44626583109988



0.472946187606348


We may also want to add some extra information to our plot above. This time instead of specifying the color manually, we use the column `hyp`, an indicator for hypertension, to specify the color. We have to make sure this vector is a factor for R to color by group. Additionally, we add a blue vertical and horizontal line using the `abline()` function to mark cutoffs for hypertension. Even though this function is called after `plot()`, the lines are automatically added to the current plot.


```R
plot(nhanes_df$sbp, nhanes_df$dbp, col=as.factor(nhanes_df$hyp), 
     xlab="Systolic Blood Pressure",
     ylab="Diastolic Blood Pressure")
abline(v=130, col="blue")
abline(h=80, col="blue")
```


    
![png](output_35_0.png)
    


### Practice Question

TODO:

## Autogenerated Plots

Above, we learned some new functions for visualizing the relationship between variables. The `GGally` package contains some useful functions for looking at multiple univariate and bivariate relationships at the same time. The `ggpairs()` function takes the data as its first argument. By default, it will plot the pairwise distributions for all columns, but we can also specify to only select a subset of columns using the `columns` argument. You can see below that it plots the box plots and density plots for each univariate sample distribution. It then plots the bivariate distributions and calculates the Pearson correlation for all pairs of continuous variables. That's a lot of information!

TODO: messages, check Pearson?


```R
ggpairs(nhanes_df, columns = c("sex", "age", "lead", "sbp", "dbp"))
```

    [1m[22m`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    [1m[22m`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    [1m[22m`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    [1m[22m`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.



    
![png](output_38_1.png)
    


Another useful function in this package is the `ggcorr()` function. In this function, it expects us to pass in a data frame with only numeric columns and it displays the correlation between all pairs where the color of each grid cell indicates the strength of the correlation. The additional argument `label=TRUE` specifies to put the correlation value on each grid cell. This is a useful way to identify pairs of strongly correlated variables. 


```R
nhanes_cont <- nhanes_df[,c("age", "lead", "sbp", "dbp")]
ggcorr(nhanes_cont, label=TRUE)
```


    
![png](output_40_0.png)
    


## Tables

Another useful way to display information about your data is through tables. For example, it is standard practice in articles to have the first table in the paper give information about the study sample such as the mean and standard deviation for all continuous variables and the proportions for categorical variables. The `gt` package is designed to create beautiful tables that can include footnotes, titles, column labels, etc. The `gtsummary` package is an extension of this package that can create summary tables. We will focus on the latter and come back to the capabilities of `gt` in Chapter X.

TODO: update chapter ref

To start, we create a gt object using the first six rows of our data using the `gt()` function. In R Markdown, this would be knit as a table. Since we are using this within a Jupyter notebook, we need to pass this to another function to make sure it displays correctly as HTML. The pipe operator `%>%` passes the result on the left hand side as the first argument to the function on the right hand side. You can see the difference in the formatting.


```R
gt(head(nhanes_df)) %>% gt:::as.tags.gt_tbl()
```


<!doctype html>
<html>
	<head>
		<meta charset="utf-8">

	</head>
	<body>
		<div id="uiuqjotcyh" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
  <style>#uiuqjotcyh table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#uiuqjotcyh thead, #uiuqjotcyh tbody, #uiuqjotcyh tfoot, #uiuqjotcyh tr, #uiuqjotcyh td, #uiuqjotcyh th {
  border-style: none;
}

#uiuqjotcyh p {
  margin: 0;
  padding: 0;
}

#uiuqjotcyh .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#uiuqjotcyh .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#uiuqjotcyh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#uiuqjotcyh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#uiuqjotcyh .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#uiuqjotcyh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uiuqjotcyh .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#uiuqjotcyh .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#uiuqjotcyh .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#uiuqjotcyh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#uiuqjotcyh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#uiuqjotcyh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#uiuqjotcyh .gt_spanner_row {
  border-bottom-style: hidden;
}

#uiuqjotcyh .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#uiuqjotcyh .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#uiuqjotcyh .gt_from_md > :first-child {
  margin-top: 0;
}

#uiuqjotcyh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#uiuqjotcyh .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#uiuqjotcyh .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#uiuqjotcyh .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#uiuqjotcyh .gt_row_group_first td {
  border-top-width: 2px;
}

#uiuqjotcyh .gt_row_group_first th {
  border-top-width: 2px;
}

#uiuqjotcyh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uiuqjotcyh .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#uiuqjotcyh .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#uiuqjotcyh .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uiuqjotcyh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uiuqjotcyh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#uiuqjotcyh .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#uiuqjotcyh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#uiuqjotcyh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uiuqjotcyh .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#uiuqjotcyh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#uiuqjotcyh .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#uiuqjotcyh .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#uiuqjotcyh .gt_left {
  text-align: left;
}

#uiuqjotcyh .gt_center {
  text-align: center;
}

#uiuqjotcyh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#uiuqjotcyh .gt_font_normal {
  font-weight: normal;
}

#uiuqjotcyh .gt_font_bold {
  font-weight: bold;
}

#uiuqjotcyh .gt_font_italic {
  font-style: italic;
}

#uiuqjotcyh .gt_super {
  font-size: 65%;
}

#uiuqjotcyh .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#uiuqjotcyh .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#uiuqjotcyh .gt_indent_1 {
  text-indent: 5px;
}

#uiuqjotcyh .gt_indent_2 {
  text-indent: 10px;
}

#uiuqjotcyh .gt_indent_3 {
  text-indent: 15px;
}

#uiuqjotcyh .gt_indent_4 {
  text-indent: 20px;
}

#uiuqjotcyh .gt_indent_5 {
  text-indent: 25px;
}
</style>
  <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>

    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="id">id</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="age">age</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="sex">sex</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="race">race</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="education">education</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="income">income</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="smoke">smoke</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="year">year</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="lead">lead</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="bmi_cat">bmi_cat</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="dbp">dbp</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="lead_quantile">lead_quantile</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="sbp">sbp</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="hyp">hyp</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="alc">alc</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="ever_smoke">ever_smoke</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="id" class="gt_row gt_right">93705</td>
<td headers="age" class="gt_row gt_right">66</td>
<td headers="sex" class="gt_row gt_center">Female</td>
<td headers="race" class="gt_row gt_center">Non-Hispanic Black</td>
<td headers="education" class="gt_row gt_center">LessThanHS</td>
<td headers="income" class="gt_row gt_right">0.82</td>
<td headers="smoke" class="gt_row gt_center">QuitSmoke</td>
<td headers="year" class="gt_row gt_right">2017</td>
<td headers="lead" class="gt_row gt_right">2.98</td>
<td headers="bmi_cat" class="gt_row gt_center">BMI&gt;=30</td>
<td headers="dbp" class="gt_row gt_right">74</td>
<td headers="lead_quantile" class="gt_row gt_center">Q4</td>
<td headers="sbp" class="gt_row gt_right">198</td>
<td headers="hyp" class="gt_row gt_right">1</td>
<td headers="alc" class="gt_row gt_left">Yes</td>
<td headers="ever_smoke" class="gt_row gt_left">Yes</td></tr>
    <tr><td headers="id" class="gt_row gt_right">93711</td>
<td headers="age" class="gt_row gt_right">56</td>
<td headers="sex" class="gt_row gt_center">Male</td>
<td headers="race" class="gt_row gt_center">Other Race</td>
<td headers="education" class="gt_row gt_center">MoreThanHS</td>
<td headers="income" class="gt_row gt_right">5.00</td>
<td headers="smoke" class="gt_row gt_center">NeverSmoke</td>
<td headers="year" class="gt_row gt_right">2017</td>
<td headers="lead" class="gt_row gt_right">2.15</td>
<td headers="bmi_cat" class="gt_row gt_center">BMI&lt;=25</td>
<td headers="dbp" class="gt_row gt_right">64</td>
<td headers="lead_quantile" class="gt_row gt_center">Q3</td>
<td headers="sbp" class="gt_row gt_right">102</td>
<td headers="hyp" class="gt_row gt_right">0</td>
<td headers="alc" class="gt_row gt_left">Yes</td>
<td headers="ever_smoke" class="gt_row gt_left">No</td></tr>
    <tr><td headers="id" class="gt_row gt_right">93713</td>
<td headers="age" class="gt_row gt_right">67</td>
<td headers="sex" class="gt_row gt_center">Male</td>
<td headers="race" class="gt_row gt_center">Non-Hispanic White</td>
<td headers="education" class="gt_row gt_center">HS</td>
<td headers="income" class="gt_row gt_right">2.65</td>
<td headers="smoke" class="gt_row gt_center">StillSmoke</td>
<td headers="year" class="gt_row gt_right">2017</td>
<td headers="lead" class="gt_row gt_right">3.71</td>
<td headers="bmi_cat" class="gt_row gt_center">BMI&lt;=25</td>
<td headers="dbp" class="gt_row gt_right">72</td>
<td headers="lead_quantile" class="gt_row gt_center">Q4</td>
<td headers="sbp" class="gt_row gt_right">106</td>
<td headers="hyp" class="gt_row gt_right">0</td>
<td headers="alc" class="gt_row gt_left">Yes</td>
<td headers="ever_smoke" class="gt_row gt_left">Yes</td></tr>
    <tr><td headers="id" class="gt_row gt_right">93714</td>
<td headers="age" class="gt_row gt_right">54</td>
<td headers="sex" class="gt_row gt_center">Female</td>
<td headers="race" class="gt_row gt_center">Non-Hispanic Black</td>
<td headers="education" class="gt_row gt_center">MoreThanHS</td>
<td headers="income" class="gt_row gt_right">1.86</td>
<td headers="smoke" class="gt_row gt_center">QuitSmoke</td>
<td headers="year" class="gt_row gt_right">2017</td>
<td headers="lead" class="gt_row gt_right">0.71</td>
<td headers="bmi_cat" class="gt_row gt_center">BMI&gt;=30</td>
<td headers="dbp" class="gt_row gt_right">72</td>
<td headers="lead_quantile" class="gt_row gt_center">Q1</td>
<td headers="sbp" class="gt_row gt_right">160</td>
<td headers="hyp" class="gt_row gt_right">1</td>
<td headers="alc" class="gt_row gt_left">Yes</td>
<td headers="ever_smoke" class="gt_row gt_left">Yes</td></tr>
    <tr><td headers="id" class="gt_row gt_right">93716</td>
<td headers="age" class="gt_row gt_right">61</td>
<td headers="sex" class="gt_row gt_center">Male</td>
<td headers="race" class="gt_row gt_center">Other Race</td>
<td headers="education" class="gt_row gt_center">MoreThanHS</td>
<td headers="income" class="gt_row gt_right">5.00</td>
<td headers="smoke" class="gt_row gt_center">QuitSmoke</td>
<td headers="year" class="gt_row gt_right">2017</td>
<td headers="lead" class="gt_row gt_right">1.99</td>
<td headers="bmi_cat" class="gt_row gt_center">BMI&gt;=30</td>
<td headers="dbp" class="gt_row gt_right">70</td>
<td headers="lead_quantile" class="gt_row gt_center">Q3</td>
<td headers="sbp" class="gt_row gt_right">122</td>
<td headers="hyp" class="gt_row gt_right">0</td>
<td headers="alc" class="gt_row gt_left">Yes</td>
<td headers="ever_smoke" class="gt_row gt_left">Yes</td></tr>
    <tr><td headers="id" class="gt_row gt_right">93717</td>
<td headers="age" class="gt_row gt_right">22</td>
<td headers="sex" class="gt_row gt_center">Male</td>
<td headers="race" class="gt_row gt_center">Non-Hispanic White</td>
<td headers="education" class="gt_row gt_center">HS</td>
<td headers="income" class="gt_row gt_right">1.49</td>
<td headers="smoke" class="gt_row gt_center">StillSmoke</td>
<td headers="year" class="gt_row gt_right">2017</td>
<td headers="lead" class="gt_row gt_right">1.93</td>
<td headers="bmi_cat" class="gt_row gt_center">BMI&lt;=25</td>
<td headers="dbp" class="gt_row gt_right">68</td>
<td headers="lead_quantile" class="gt_row gt_center">Q3</td>
<td headers="sbp" class="gt_row gt_right">116</td>
<td headers="hyp" class="gt_row gt_right">0</td>
<td headers="alc" class="gt_row gt_left">Yes</td>
<td headers="ever_smoke" class="gt_row gt_left">Yes</td></tr>
  </tbody>


</table>
</div>
	</body>
</html>



We now show how to use the `tbl_summary()` function in the `gtsummary` package. The first argument to this function is the data frame again. By default, this function will summarize all the variables in the data. Instead, we use the `include` argument to specify a list of variables to include. We this pipe this result to `as_gt()` which creates a gt table from the summary output before passing to the last function again to display the HTML table. Note that the table computes the total number of observations and computes the proportions for categorical variables and the interquartile range for continuous variables.


```R
tbl_summary(nhanes_df, include= c("sex", "race", "age", "education", "smoke",
                                  "bmi_cat", "lead", "sbp", "dbp", "hyp")) %>% 
  as_gt() %>% 
  gt:::as.tags.gt_tbl()
```


<!doctype html>
<html>
	<head>
		<meta charset="utf-8">

	</head>
	<body>
		<div id="xgdyczlzqk" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
  <style>#xgdyczlzqk table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#xgdyczlzqk thead, #xgdyczlzqk tbody, #xgdyczlzqk tfoot, #xgdyczlzqk tr, #xgdyczlzqk td, #xgdyczlzqk th {
  border-style: none;
}

#xgdyczlzqk p {
  margin: 0;
  padding: 0;
}

#xgdyczlzqk .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#xgdyczlzqk .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#xgdyczlzqk .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#xgdyczlzqk .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#xgdyczlzqk .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#xgdyczlzqk .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xgdyczlzqk .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#xgdyczlzqk .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#xgdyczlzqk .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#xgdyczlzqk .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xgdyczlzqk .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xgdyczlzqk .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#xgdyczlzqk .gt_spanner_row {
  border-bottom-style: hidden;
}

#xgdyczlzqk .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#xgdyczlzqk .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#xgdyczlzqk .gt_from_md > :first-child {
  margin-top: 0;
}

#xgdyczlzqk .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xgdyczlzqk .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#xgdyczlzqk .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#xgdyczlzqk .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#xgdyczlzqk .gt_row_group_first td {
  border-top-width: 2px;
}

#xgdyczlzqk .gt_row_group_first th {
  border-top-width: 2px;
}

#xgdyczlzqk .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xgdyczlzqk .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#xgdyczlzqk .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#xgdyczlzqk .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xgdyczlzqk .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xgdyczlzqk .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xgdyczlzqk .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#xgdyczlzqk .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xgdyczlzqk .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xgdyczlzqk .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#xgdyczlzqk .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#xgdyczlzqk .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#xgdyczlzqk .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#xgdyczlzqk .gt_left {
  text-align: left;
}

#xgdyczlzqk .gt_center {
  text-align: center;
}

#xgdyczlzqk .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xgdyczlzqk .gt_font_normal {
  font-weight: normal;
}

#xgdyczlzqk .gt_font_bold {
  font-weight: bold;
}

#xgdyczlzqk .gt_font_italic {
  font-style: italic;
}

#xgdyczlzqk .gt_super {
  font-size: 65%;
}

#xgdyczlzqk .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#xgdyczlzqk .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#xgdyczlzqk .gt_indent_1 {
  text-indent: 5px;
}

#xgdyczlzqk .gt_indent_2 {
  text-indent: 10px;
}

#xgdyczlzqk .gt_indent_3 {
  text-indent: 15px;
}

#xgdyczlzqk .gt_indent_4 {
  text-indent: 20px;
}

#xgdyczlzqk .gt_indent_5 {
  text-indent: 25px;
}
</style>
  <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>

    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;N = 2,763&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>N = 2,763</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">sex</td>
<td headers="stat_0" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Male</td>
<td headers="stat_0" class="gt_row gt_center">1,393 (50%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Female</td>
<td headers="stat_0" class="gt_row gt_center">1,370 (50%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">race</td>
<td headers="stat_0" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Mexican American</td>
<td headers="stat_0" class="gt_row gt_center">382 (14%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Other Hispanic</td>
<td headers="stat_0" class="gt_row gt_center">240 (8.7%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Non-Hispanic White</td>
<td headers="stat_0" class="gt_row gt_center">1,048 (38%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Non-Hispanic Black</td>
<td headers="stat_0" class="gt_row gt_center">620 (22%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Other Race</td>
<td headers="stat_0" class="gt_row gt_center">473 (17%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">age</td>
<td headers="stat_0" class="gt_row gt_center">48 (33, 62)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">education</td>
<td headers="stat_0" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    LessThanHS</td>
<td headers="stat_0" class="gt_row gt_center">400 (14%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    HS</td>
<td headers="stat_0" class="gt_row gt_center">640 (23%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    MoreThanHS</td>
<td headers="stat_0" class="gt_row gt_center">1,723 (62%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">smoke</td>
<td headers="stat_0" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    NeverSmoke</td>
<td headers="stat_0" class="gt_row gt_center">1,514 (55%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    QuitSmoke</td>
<td headers="stat_0" class="gt_row gt_center">680 (25%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    StillSmoke</td>
<td headers="stat_0" class="gt_row gt_center">569 (21%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">bmi_cat</td>
<td headers="stat_0" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    BMI&lt;=25</td>
<td headers="stat_0" class="gt_row gt_center">709 (26%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    25&lt;BMI&lt;30</td>
<td headers="stat_0" class="gt_row gt_center">854 (31%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    BMI&gt;=30</td>
<td headers="stat_0" class="gt_row gt_center">1,200 (43%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">lead</td>
<td headers="stat_0" class="gt_row gt_center">0.92 (0.56, 1.44)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">sbp</td>
<td headers="stat_0" class="gt_row gt_center">122 (112, 134)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">dbp</td>
<td headers="stat_0" class="gt_row gt_center">74 (66, 80)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">hyp</td>
<td headers="stat_0" class="gt_row gt_center">1,595 (58%)</td></tr>
  </tbody>

  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="2"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> n (%); Median (IQR)</td>
    </tr>
  </tfoot>
</table>
</div>
	</body>
</html>



We can update some of the arguments to update our table. This time we specify that we want to stratify our table by the hypertension status, which summarizes the data by this grouping. Additionally, we change how continuous variables are summarized by specifying that we want to report the mean and standard deviation.


```R
tbl_summary(nhanes_df, include= c("sex", "race", "age", "education", "smoke",
                                  "bmi_cat", "lead", "sbp", "dbp", "hyp"),
           by = "hyp", statistic = list(all_continuous() ~ "{mean} ({sd})")) %>% 
  as_gt() %>% 
  gt:::as.tags.gt_tbl()
```


<!doctype html>
<html>
	<head>
		<meta charset="utf-8">

	</head>
	<body>
		<div id="eswvdotdqk" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
  <style>#eswvdotdqk table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#eswvdotdqk thead, #eswvdotdqk tbody, #eswvdotdqk tfoot, #eswvdotdqk tr, #eswvdotdqk td, #eswvdotdqk th {
  border-style: none;
}

#eswvdotdqk p {
  margin: 0;
  padding: 0;
}

#eswvdotdqk .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#eswvdotdqk .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#eswvdotdqk .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#eswvdotdqk .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#eswvdotdqk .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#eswvdotdqk .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#eswvdotdqk .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#eswvdotdqk .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#eswvdotdqk .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#eswvdotdqk .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#eswvdotdqk .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#eswvdotdqk .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#eswvdotdqk .gt_spanner_row {
  border-bottom-style: hidden;
}

#eswvdotdqk .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#eswvdotdqk .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#eswvdotdqk .gt_from_md > :first-child {
  margin-top: 0;
}

#eswvdotdqk .gt_from_md > :last-child {
  margin-bottom: 0;
}

#eswvdotdqk .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#eswvdotdqk .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#eswvdotdqk .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#eswvdotdqk .gt_row_group_first td {
  border-top-width: 2px;
}

#eswvdotdqk .gt_row_group_first th {
  border-top-width: 2px;
}

#eswvdotdqk .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#eswvdotdqk .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#eswvdotdqk .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#eswvdotdqk .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#eswvdotdqk .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#eswvdotdqk .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#eswvdotdqk .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#eswvdotdqk .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#eswvdotdqk .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#eswvdotdqk .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#eswvdotdqk .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#eswvdotdqk .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#eswvdotdqk .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#eswvdotdqk .gt_left {
  text-align: left;
}

#eswvdotdqk .gt_center {
  text-align: center;
}

#eswvdotdqk .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#eswvdotdqk .gt_font_normal {
  font-weight: normal;
}

#eswvdotdqk .gt_font_bold {
  font-weight: bold;
}

#eswvdotdqk .gt_font_italic {
  font-style: italic;
}

#eswvdotdqk .gt_super {
  font-size: 65%;
}

#eswvdotdqk .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#eswvdotdqk .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#eswvdotdqk .gt_indent_1 {
  text-indent: 5px;
}

#eswvdotdqk .gt_indent_2 {
  text-indent: 10px;
}

#eswvdotdqk .gt_indent_3 {
  text-indent: 15px;
}

#eswvdotdqk .gt_indent_4 {
  text-indent: 20px;
}

#eswvdotdqk .gt_indent_5 {
  text-indent: 25px;
}
</style>
  <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>

    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;0&lt;/strong&gt;, N = 1,168&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>0</strong>, N = 1,168<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;1&lt;/strong&gt;, N = 1,595&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>1</strong>, N = 1,595<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">sex</td>
<td headers="stat_1" class="gt_row gt_center"></td>
<td headers="stat_2" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Male</td>
<td headers="stat_1" class="gt_row gt_center">484 (41%)</td>
<td headers="stat_2" class="gt_row gt_center">909 (57%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Female</td>
<td headers="stat_1" class="gt_row gt_center">684 (59%)</td>
<td headers="stat_2" class="gt_row gt_center">686 (43%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">race</td>
<td headers="stat_1" class="gt_row gt_center"></td>
<td headers="stat_2" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Mexican American</td>
<td headers="stat_1" class="gt_row gt_center">196 (17%)</td>
<td headers="stat_2" class="gt_row gt_center">186 (12%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Other Hispanic</td>
<td headers="stat_1" class="gt_row gt_center">107 (9.2%)</td>
<td headers="stat_2" class="gt_row gt_center">133 (8.3%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Non-Hispanic White</td>
<td headers="stat_1" class="gt_row gt_center">439 (38%)</td>
<td headers="stat_2" class="gt_row gt_center">609 (38%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Non-Hispanic Black</td>
<td headers="stat_1" class="gt_row gt_center">206 (18%)</td>
<td headers="stat_2" class="gt_row gt_center">414 (26%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Other Race</td>
<td headers="stat_1" class="gt_row gt_center">220 (19%)</td>
<td headers="stat_2" class="gt_row gt_center">253 (16%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">age</td>
<td headers="stat_1" class="gt_row gt_center">40 (15)</td>
<td headers="stat_2" class="gt_row gt_center">55 (15)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">education</td>
<td headers="stat_1" class="gt_row gt_center"></td>
<td headers="stat_2" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    LessThanHS</td>
<td headers="stat_1" class="gt_row gt_center">157 (13%)</td>
<td headers="stat_2" class="gt_row gt_center">243 (15%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    HS</td>
<td headers="stat_1" class="gt_row gt_center">258 (22%)</td>
<td headers="stat_2" class="gt_row gt_center">382 (24%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    MoreThanHS</td>
<td headers="stat_1" class="gt_row gt_center">753 (64%)</td>
<td headers="stat_2" class="gt_row gt_center">970 (61%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">smoke</td>
<td headers="stat_1" class="gt_row gt_center"></td>
<td headers="stat_2" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    NeverSmoke</td>
<td headers="stat_1" class="gt_row gt_center">700 (60%)</td>
<td headers="stat_2" class="gt_row gt_center">814 (51%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    QuitSmoke</td>
<td headers="stat_1" class="gt_row gt_center">229 (20%)</td>
<td headers="stat_2" class="gt_row gt_center">451 (28%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    StillSmoke</td>
<td headers="stat_1" class="gt_row gt_center">239 (20%)</td>
<td headers="stat_2" class="gt_row gt_center">330 (21%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">bmi_cat</td>
<td headers="stat_1" class="gt_row gt_center"></td>
<td headers="stat_2" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    BMI&lt;=25</td>
<td headers="stat_1" class="gt_row gt_center">410 (35%)</td>
<td headers="stat_2" class="gt_row gt_center">299 (19%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    25&lt;BMI&lt;30</td>
<td headers="stat_1" class="gt_row gt_center">357 (31%)</td>
<td headers="stat_2" class="gt_row gt_center">497 (31%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    BMI&gt;=30</td>
<td headers="stat_1" class="gt_row gt_center">401 (34%)</td>
<td headers="stat_2" class="gt_row gt_center">799 (50%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">lead</td>
<td headers="stat_1" class="gt_row gt_center">1.03 (1.14)</td>
<td headers="stat_2" class="gt_row gt_center">1.36 (1.23)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">sbp</td>
<td headers="stat_1" class="gt_row gt_center">112 (9)</td>
<td headers="stat_2" class="gt_row gt_center">134 (18)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">dbp</td>
<td headers="stat_1" class="gt_row gt_center">67 (8)</td>
<td headers="stat_2" class="gt_row gt_center">78 (14)</td></tr>
  </tbody>

  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="3"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> n (%); Mean (SD)</td>
    </tr>
  </tfoot>
</table>
</div>
	</body>
</html>



## Exercises

For these exercises, we will be using the **NHANES** data.

1. Using the numerical and graphical summaries, describe the distribution of diastolic blood pressure `dbp` and `age` among study participants, respectively. 



```R
## solutions:
library(RforHDSdata)
data(NHANESsample)

# bbp
summary(NHANESsample$dbp)
hist(NHANESsample$dbp)

# age
summary(NHANESsample$age)
hist(NHANESsample$age)
```


       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
       0.00   62.00   70.00   70.36   78.00  130.00 



       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
      20.00   34.00   48.00   49.18   63.00   85.00 



    
![png](output_50_2.png)
    



    
![png](output_50_3.png)
    


2. Subset 20-to-55-year-old females and randomly select 1000 participants from the entire dataset. Using the random sample, `nhanes.samp`, explore how does blood pressure vary by age? Is there a remarkable trend in blood pressure between those females? 



```R
NHANESsample.subset <- subset(NHANESsample, 
                              NHANESsample$sex=="Female" & NHANESsample$age>=20 & NHANESsample$age<=55)
nhanes.samp <- sample_n(NHANESsample.subset, size=1000, replace = FALSE)
plot(nhanes.samp$age, nhanes.samp$dbp)
```


    Error in sample_n(NHANESsample.subset, size = 1000, replace = FALSE): could not find function "sample_n"
    Traceback:



3. Repeat exercise 2 for males.


```R
subset.males <- subset(NHANESsample, 
                              NHANESsample$sex=="Male" & NHANESsample$age>=20 & NHANESsample$age<=55)
nhanes.samp.males <- sample_n(subset.males, size=1000, replace = FALSE)
plot(nhanes.samp.males$age, nhanes.samp.males$dbp)
```

4. For males between the ages of 50-59, compare blood pressure across race as reported in the race variable. Order resulting tables from lowest to highest average blood pressure.


```R
subset.males.1 <- subset(NHANESsample, 
                         NHANESsample$sex=="Male" & NHANESsample$age>=50 & NHANESsample$age<=59)
subset.males.1$race <- as.factor(subset.males.1$race)
boxplot(subset.males.1$dbp ~ subset.males.1$race)

levels(subset.males.1$race)
summary(subset.males.1$dbp[subset.males.1$race=="Non-Hispanic White"])[4]
summary(subset.males.1$dbp[subset.males.1$race=="Mexican American"])[4]
summary(subset.males.1$dbp[subset.males.1$race=="Other Race" ])[4]
summary(subset.males.1$dbp[subset.males.1$race=="Other Hispanic"])[4]
summary(subset.males.1$dbp[subset.males.1$race=="Non-Hispanic Black"])[4]
```

5. Examine the relationship between BMI levels with blood pressure, age, and income using appropriate correlation matrices and probability.



```R
library(ggcorrplot)
corr <- round(cor(NHANESsample[,c(2,6,11)]), 1)
ggcorrplot(corr, method = "square")
```
