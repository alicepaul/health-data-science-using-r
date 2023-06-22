# Working with Data Files in R

In this chapter, we will start analyzing a data file. To start, we need to load our data into R. This requires identifying the type of data file we have (e.g. .csv, .xlsx, .dta) and finding the appropriate function to load in the data to R. This will create a data frame object containing the information. This chapter will then show how to find information about the data columns including finding missing values, summarizing columns, and subsetting the data. Additionally, we look at how to create new columns through some simple transformations.  

In this chapter and all future chapters, we will load in the libraries needed for this chapter at the start of the chapter. In this chapter, we need a single library `RforHDSdata` that contains the sample data sets used in this book.


```R
# Chapter 3 libraries
library(RforHDSdata)
```

## Importing and Exporting Data

The data we will use contains information about 21,658 patients who visited one of the University of Pittsburgh’s seven pain management clinics. This includes patient-reported pain assessments using the Collaborative Health Outcomes Information Registry (CHOIR) at baseline and at a 3-month follow-up. Use the help operator to learn more about the source of this data and to read the variable descriptions `?pain`. Since this data is available in our R package, we can use the `data` function to load this data into our environment. Note that this data has 21,659 rows and 92 columns.

TODO: check dimensions?


```R
data(pain)
dim(pain)
```


<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>21659</li><li>92</li></ol>



In general, our data is not available in an R package and instead exists in one or more data files. In order to load in this data, we need to find the corresponding function that works for the file type we have. For example, we can load a csv file using the `read.csv` function (part of base R) or using the `read_csv` function from the `readr` package, both shown in Chapter 1. Looking at the print output below we can see that there is slight difference in the data structure and data types storing the data. The function `read.csv` loads the data as a data frame whereas `read_csv` returns an object of type `spec_tbl_df`. This is special type of data frame called a tibble that is used by the `tidyverse` packages. We will cover this data structure in Chapter 5. You can use either function to read in a csv file.


```R
read.csv("data/fake_names.csv")
```


<table class="dataframe">
<caption>A data.frame: 6 × 5</caption>
<thead>
	<tr><th scope=col>Name</th><th scope=col>Age</th><th scope=col>DOB</th><th scope=col>City</th><th scope=col>State</th></tr>
	<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>
</thead>
<tbody>
	<tr><td>Ken Irwin          </td><td>37</td><td>6/28/85</td><td>Providence     </td><td>RI</td></tr>
	<tr><td>Delores Whittington</td><td>56</td><td>4/28/67</td><td>Smithfield     </td><td>RI</td></tr>
	<tr><td>Daniel Hughes      </td><td>41</td><td>5/22/82</td><td>Providence     </td><td>RI</td></tr>
	<tr><td>Carlos Fain        </td><td>83</td><td>2/2/40 </td><td>Warren         </td><td>RI</td></tr>
	<tr><td>James Alford       </td><td>67</td><td>2/23/56</td><td>East Providence</td><td>RI</td></tr>
	<tr><td>Ruth Alvarez       </td><td>34</td><td>9/22/88</td><td>Providence     </td><td>RI</td></tr>
</tbody>
</table>




```R
readr::read_csv("data/fake_names.csv", show_col_types=FALSE)
```


<table class="dataframe">
<caption>A spec_tbl_df: 6 × 5</caption>
<thead>
	<tr><th scope=col>Name</th><th scope=col>Age</th><th scope=col>DOB</th><th scope=col>City</th><th scope=col>State</th></tr>
	<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>
</thead>
<tbody>
	<tr><td>Ken Irwin          </td><td>37</td><td>6/28/85</td><td>Providence     </td><td>RI</td></tr>
	<tr><td>Delores Whittington</td><td>56</td><td>4/28/67</td><td>Smithfield     </td><td>RI</td></tr>
	<tr><td>Daniel Hughes      </td><td>41</td><td>5/22/82</td><td>Providence     </td><td>RI</td></tr>
	<tr><td>Carlos Fain        </td><td>83</td><td>2/2/40 </td><td>Warren         </td><td>RI</td></tr>
	<tr><td>James Alford       </td><td>67</td><td>2/23/56</td><td>East Providence</td><td>RI</td></tr>
	<tr><td>Ruth Alvarez       </td><td>34</td><td>9/22/88</td><td>Providence     </td><td>RI</td></tr>
</tbody>
</table>



We may also want to save data from R into a data file we can access or share. To write a data frame from R to a csv file, we can use the `write.csv()` function. This function has three key arguments: the first agrument is the data frame in R that we want to write to a file, the second argument is the file name or the full file path where we want to write the data, and the third argument is whether or not we want to include the row names as an extra column to write. In this case, we will not include these row names. If we do not specify a full file path, R will save the file in our current working directory.


```R
df <- data.frame(x=c(1,0,1), y=c("A", "B", "C"))
write.csv(df, "data/test.csv", row.names=FALSE)
```

If you your data is not in a csv file, you may need to use another package to read in the file. The two most common packages are the `readxl` package, which makes it easy to read in Excel files, and the `haven` package, which can import SAS, SPSS, and Stata files. For each function, you need to specify the file path to the data file. 

* **Excel Files**: You can read in a .xls or .xlsx file using `readxl::read_excel()`, which allows you to specify a sheet and/or cell range within a file. (e.g. `read_excel('test.xlsx', sheet="Sheet1")`).

* **SAS**: `haven::read_sas()` reads in .sas7bdat or .sas7bcat files, `haven::read_xpt()` reads in SAS transport files

* **Stata**: `haven::read_dta()` reads in .dta files

* **SPSS**: `haven::read_spss(filepath)` reads in .spss files

## Summarizing and Creating Data Columns

We will not look at the data we have loaded into the data frame called `pain`. We use the `head()` function to print the first six rows. However, we have so many columns that all not of the columns are displayed! For those that are displayed, we can see the data type for each column under the column name. For example, the column `PATIENT_NUM` is currently a numeric column. We might consider whether we should make this a factor or a character representation. We also use the `names()` function to print all the column names. Note that columns `X101` to `X238` correspond to the body pain map. Each of these columns has a 1 if the patient indicated that body part as experiencing pain and 0 if not.


```R
head(pain)
names(pain)
```


<table class="dataframe">
<caption>A tibble: 6 × 92</caption>
<thead>
	<tr><th scope=col>PATIENT_NUM</th><th scope=col>X101</th><th scope=col>X102</th><th scope=col>X103</th><th scope=col>X104</th><th scope=col>X105</th><th scope=col>X106</th><th scope=col>X107</th><th scope=col>X108</th><th scope=col>X109</th><th scope=col>⋯</th><th scope=col>GH_MENTAL_SCORE</th><th scope=col>GH_PHYSICAL_SCORE</th><th scope=col>AGE_AT_CONTACT</th><th scope=col>BMI</th><th scope=col>CCI_TOTAL_SCORE</th><th scope=col>PAIN_INTENSITY_AVERAGE.follow_up</th><th scope=col>PAT_SEX</th><th scope=col>PAT_RACE</th><th scope=col>CCI_bin</th><th scope=col>medicaid_bin</th></tr>
	<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>⋯</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>
</thead>
<tbody>
	<tr><td>13118</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>43.5</td><td>29.6</td><td>78</td><td>33.67</td><td>0</td><td>2</td><td>male  </td><td>WHITE</td><td>No comorbidity</td><td>no</td></tr>
	<tr><td>21384</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>53.3</td><td>37.4</td><td>70</td><td>36.26</td><td>0</td><td>5</td><td>female</td><td>WHITE</td><td>No comorbidity</td><td>no</td></tr>
	<tr><td> 6240</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>48.3</td><td>37.4</td><td>75</td><td>27.25</td><td>0</td><td>6</td><td>male  </td><td>WHITE</td><td>No comorbidity</td><td>no</td></tr>
	<tr><td> 1827</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>  NA</td><td>  NA</td><td>61</td><td>   NA</td><td>0</td><td>7</td><td>male  </td><td>WHITE</td><td>No comorbidity</td><td>no</td></tr>
	<tr><td>11309</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>45.8</td><td>34.9</td><td>63</td><td>28.89</td><td>0</td><td>6</td><td>male  </td><td>WHITE</td><td>No comorbidity</td><td>no</td></tr>
	<tr><td>11093</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>31.3</td><td>26.7</td><td>54</td><td>27.32</td><td>0</td><td>0</td><td>male  </td><td>WHITE</td><td>No comorbidity</td><td>NA</td></tr>
</tbody>
</table>




<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>'PATIENT_NUM'</li><li>'X101'</li><li>'X102'</li><li>'X103'</li><li>'X104'</li><li>'X105'</li><li>'X106'</li><li>'X107'</li><li>'X108'</li><li>'X109'</li><li>'X110'</li><li>'X111'</li><li>'X112'</li><li>'X113'</li><li>'X114'</li><li>'X115'</li><li>'X116'</li><li>'X117'</li><li>'X118'</li><li>'X119'</li><li>'X120'</li><li>'X121'</li><li>'X122'</li><li>'X123'</li><li>'X124'</li><li>'X125'</li><li>'X126'</li><li>'X127'</li><li>'X128'</li><li>'X129'</li><li>'X130'</li><li>'X131'</li><li>'X132'</li><li>'X133'</li><li>'X134'</li><li>'X135'</li><li>'X136'</li><li>'X201'</li><li>'X202'</li><li>'X203'</li><li>'X204'</li><li>'X205'</li><li>'X206'</li><li>'X207'</li><li>'X208'</li><li>'X209'</li><li>'X210'</li><li>'X211'</li><li>'X212'</li><li>'X213'</li><li>'X214'</li><li>'X215'</li><li>'X216'</li><li>'X217'</li><li>'X218'</li><li>'X219'</li><li>'X220'</li><li>'X221'</li><li>'X222'</li><li>'X223'</li><li>'X224'</li><li>'X225'</li><li>'X226'</li><li>'X227'</li><li>'X228'</li><li>'X229'</li><li>'X230'</li><li>'X231'</li><li>'X232'</li><li>'X233'</li><li>'X234'</li><li>'X235'</li><li>'X236'</li><li>'X237'</li><li>'X238'</li><li>'PAIN_INTENSITY_AVERAGE'</li><li>'PROMIS_PHYSICAL_FUNCTION'</li><li>'PROMIS_PAIN_BEHAVIOR'</li><li>'PROMIS_DEPRESSION'</li><li>'PROMIS_ANXIETY'</li><li>'PROMIS_SLEEP_DISTURB_V1_0'</li><li>'PROMIS_PAIN_INTERFERENCE'</li><li>'GH_MENTAL_SCORE'</li><li>'GH_PHYSICAL_SCORE'</li><li>'AGE_AT_CONTACT'</li><li>'BMI'</li><li>'CCI_TOTAL_SCORE'</li><li>'PAIN_INTENSITY_AVERAGE.follow_up'</li><li>'PAT_SEX'</li><li>'PAT_RACE'</li><li>'CCI_bin'</li><li>'medicaid_bin'</li></ol>



Recall that the `$` operator can be used to access a single column. Alternatively, we can use double brackets `[[]]` to select a column. Below, we demonstrate both ways to find the column with the patient's average pain intensity and then find the first five values. 


```R
pain$PAIN_INTENSITY_AVERAGE[1:5]
pain[["PAIN_INTENSITY_AVERAGE"]][1:5]
```


<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>7</li><li>5</li><li>4</li><li>7</li><li>8</li></ol>




<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>7</li><li>5</li><li>4</li><li>7</li><li>8</li></ol>



### Column Summaries

To understand the range and distribution of a column's values, we can rely on some of the base R functions. The `summary()` function is a useful way to summarize a numeric column's values. Below, we can see that the pain intensity values range from 0 to 10 with a median value of 7 and that there is 1 NA value.


```R
summary(pain$PAIN_INTENSITY_AVERAGE)
```


       Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
      0.000   5.000   7.000   6.485   8.000  10.000       1 


We have already seen the `max`, `min`, `mean`, and `median` functions that could have computed some of these values for us separately. Since we do have an NA value, we add the `na.rm=TRUE` argument to these functions. Without this argument the returned value is NA. 


```R
min(pain$PAIN_INTENSITY_AVERAGE, na.rm=TRUE)
max(pain$PAIN_INTENSITY_AVERAGE, na.rm=TRUE)
mean(pain$PAIN_INTENSITY_AVERAGE, na.rm=TRUE)
median(pain$PAIN_INTENSITY_AVERAGE, na.rm=TRUE)
```


0



10



6.48527103148952



7


Additionally, the functions below are helpful for summarizing quantitative variables.

* `range()` - returns the minimum and maximum values for a numeric vector x
* `quantile()` - returns the sample quantiles for a numeric vector
* `IQR()` - returns the interquartile range for a numeric vector

By default, the `quantile()` function returns the sample quartiles. However, we can pass in a list of probabilities to use instead. For example, below we find the 0.1 and 0.9 quantiles. Again, we add the `na.rm=TRUE` argument. 


```R
quantile(pain$PAIN_INTENSITY_AVERAGE, probs = c(0.1, 0.9), na.rm=TRUE)
```


<style>
.dl-inline {width: auto; margin:0; padding: 0}
.dl-inline>dt, .dl-inline>dd {float: none; width: auto; display: inline-block}
.dl-inline>dt::after {content: ":\0020"; padding-right: .5ex}
.dl-inline>dt:not(:first-of-type) {padding-left: .5ex}
</style><dl class=dl-inline><dt>10%</dt><dd>4</dd><dt>90%</dt><dd>9</dd></dl>



We can also plot a histogram of the sample distribution using the `hist()` function. 


```R
hist(pain$PAIN_INTENSITY_AVERAGE)
```


    
![png](output_22_0.png)
    


### Practice Question

TODO: summarize variable

The column `PAT_SEX` corresponds to the reported patient sex. For categorical variables, it is useful to use the `table()` function. This returns the counts for each possible value. By default, `table()` ignores NA values. However, we can set `useNA="always"` to also count the number of NA values. Additionally, we can use the `prop.table()` function to convert this to proportions. This column a single missing value and we can see that around 60% of patients are female.


```R
table(pain$PAT_SEX, useNA="always")
```


    
    female   male   <NA> 
     13102   8556      1 



```R
prop.table(table(pain$PAT_SEX))
```


    
       female      male 
    0.6049497 0.3950503 


Note that this column is not actually a factor variable yet. We can convert it to one using `as.factor()`. 


```R
is.factor(pain$PAT_SEX)
```


FALSE



```R
pain$PAT_SEX <- as.factor(pain$PAT_SEX)
is.factor(pain$PAT_SEX)
```


TRUE


### Other Summary Functions

Sometimes we want to summarize some information across multiple columns or rows. We can use the `rowSums()` and `colSums()` functions to sum over the rows or columns of a matrix or data frame. We first subset the data to the body pain maps. In the first line of code I find the column names and select those pertaining to these variables. This allows me to select those columns in the second line of code and store this subset of the data as a new data frame called `pain_body_map`.  


```R
body_map_cols <- names(pain)[2:75]
pain_body_map <- pain[, body_map_cols]
head(pain_body_map)
```


<table class="dataframe">
<caption>A tibble: 6 × 74</caption>
<thead>
	<tr><th scope=col>X101</th><th scope=col>X102</th><th scope=col>X103</th><th scope=col>X104</th><th scope=col>X105</th><th scope=col>X106</th><th scope=col>X107</th><th scope=col>X108</th><th scope=col>X109</th><th scope=col>X110</th><th scope=col>⋯</th><th scope=col>X229</th><th scope=col>X230</th><th scope=col>X231</th><th scope=col>X232</th><th scope=col>X233</th><th scope=col>X234</th><th scope=col>X235</th><th scope=col>X236</th><th scope=col>X237</th><th scope=col>X238</th></tr>
	<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>⋯</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>
</thead>
<tbody>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>0</td><td>0</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>0</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>⋯</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td>1</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>1</td><td>⋯</td><td>0</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>
</tbody>
</table>



I now compute the row sums and column sums on this subset of data. The row sum for each patient is the total number of body parts selected as experiencing pain whereas the column sum for each pain region is the total number of patients who experience pain in that area. The histogram below shows that most people select a low number of total regions.


```R
hist(rowSums(pain_body_map))
```


    
![png](output_33_0.png)
    


We can also see that some body parts are more often selected. We create a vector called `perc_patients` below by finding the total number of patients who selected each region divided by the total number of patients. The histogram shows that some body regions are selected by over 50% of patients!


```R
perc_patients <- colSums(pain_body_map, na.rm=TRUE)/nrow(pain_body_map)
hist(perc_patients)
```


    
![png](output_35_0.png)
    


We can use the `which.max()` function to see that region `X219` is selected the most number of times. This corresponds to lower back pain.


```R
which.max(perc_patients)
```


<strong>X219:</strong> 55


Another pair of useful functions are `pmin` and `pmax`. These functions take at least two vectors (of the same length) and finds the pairwise minimum of maximum. For example, if we want to create a new variable `lower_back_pain`, which corresponds to whether someone selects *either* X218 or X219 we can use the `pmax` function to find the maximum value between columns `X218` and `X219`. We can see that almost 60% of patients select at least one of these regions. 


```R
lower_back <- pmax(pain_body_map$X218, pain_body_map$X219)
prop.table(table(lower_back))
```


    lower_back
            0         1 
    0.4053929 0.5946071 


We might want to store the total number of pain regions and our indicator of whether a patient has lower back pain as new columns. We use our code above to create new columns in the pain data using the `$` operator. To be consistent with the variable naming in the data we use all upper case for our variable names. The `dim()` function shows that our data has grown by two columns, as expected. 


```R
pain$NUM_REGIONS <- rowSums(pain_body_map)
pain$LOWER_BACK <- lower_back
dim(pain)
```


<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>21659</li><li>94</li></ol>



Another useful function that allows us to compute over the rows or columns of a matrix or data frame is the `apply` function. The apply function takes in three arguments. The first agrument is the data frame or matrix, the second argument indicates whether to computer over the rows (`1`) or columns (`2`), and the last argument is the function to apply. The first example finds the maximum value for each row in the data frame `pain_body_map`. Taking the minimum value here shows that every patient selected at least one region. In the second example we find the sum over the columns and is equivalent to the example using `colSums` above. In this case, we added the `na.rm=TRUE` argument to the `apply` function to use when calculating the summation.


```R
any_selected <- apply(pain_body_map, 1, max)
min(any_selected, na.rm=TRUE)
```


1



```R
perc_patients <- apply(pain_body_map, 2, sum, na.rm=TRUE)/nrow(pain_body_map)
summary(perc_patients)
```


       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    0.03227 0.06966 0.13620 0.14375 0.18125 0.54190 


### Practice Question

TODO: something about apply and colSums or rowSums

### Missing values, Infinite values, and NaN values

As we saw above, this data contains some missing values, which are represented as `NA` in R. R treats these values exactly as if they are unknown. This is why we have to add the `na.rm=TRUE` argument to functions like `sum()` and `max()`. In the example below, we can see that R figures out that 1 plus an unknown number is also unknown!


```R
NA+1
```


&lt;NA&gt;


For a single column, we can find the number of missing values using a function `is.na()`. This function returns `TRUE` if the value is NA and `FALSE` otherwise. We can then sum up these values since each `TRUE` value corresponds to a value of 1 and `FALSE` corresponds to a value of 0. Below we can see that there is a single NA value for the column `PATIENT_NUM`, which is the patient ID number.


```R
sum(is.na(pain$PATIENT_NUM))
```


1


If we want to apply this to every column, we can use the `apply` function. Since we want to apply this over the columns, the second argument has value 2. Recall that the last argument is the function we want to call for each column. In this case, we want to apply the combination of the `sum()` and `is.na()` function. To do so, we have to specify this function ourselves. This is called an *anonymous function* since it doesn't have a name. 


```R
apply(pain, 2, function(x) sum(is.na(x)))
```


<style>
.dl-inline {width: auto; margin:0; padding: 0}
.dl-inline>dt, .dl-inline>dd {float: none; width: auto; display: inline-block}
.dl-inline>dt::after {content: ":\0020"; padding-right: .5ex}
.dl-inline>dt:not(:first-of-type) {padding-left: .5ex}
</style><dl class=dl-inline><dt>PATIENT_NUM</dt><dd>1</dd><dt>X101</dt><dd>1</dd><dt>X102</dt><dd>1</dd><dt>X103</dt><dd>1</dd><dt>X104</dt><dd>1</dd><dt>X105</dt><dd>1</dd><dt>X106</dt><dd>1</dd><dt>X107</dt><dd>1</dd><dt>X108</dt><dd>1</dd><dt>X109</dt><dd>1</dd><dt>X110</dt><dd>1</dd><dt>X111</dt><dd>1</dd><dt>X112</dt><dd>1</dd><dt>X113</dt><dd>1</dd><dt>X114</dt><dd>1</dd><dt>X115</dt><dd>1</dd><dt>X116</dt><dd>1</dd><dt>X117</dt><dd>1</dd><dt>X118</dt><dd>1</dd><dt>X119</dt><dd>1</dd><dt>X120</dt><dd>1</dd><dt>X121</dt><dd>1</dd><dt>X122</dt><dd>1</dd><dt>X123</dt><dd>1</dd><dt>X124</dt><dd>1</dd><dt>X125</dt><dd>1</dd><dt>X126</dt><dd>1</dd><dt>X127</dt><dd>1</dd><dt>X128</dt><dd>1</dd><dt>X129</dt><dd>1</dd><dt>X130</dt><dd>1</dd><dt>X131</dt><dd>1</dd><dt>X132</dt><dd>1</dd><dt>X133</dt><dd>1</dd><dt>X134</dt><dd>1</dd><dt>X135</dt><dd>1</dd><dt>X136</dt><dd>1</dd><dt>X201</dt><dd>1</dd><dt>X202</dt><dd>1</dd><dt>X203</dt><dd>1</dd><dt>X204</dt><dd>1</dd><dt>X205</dt><dd>1</dd><dt>X206</dt><dd>1</dd><dt>X207</dt><dd>1</dd><dt>X208</dt><dd>1</dd><dt>X209</dt><dd>1</dd><dt>X210</dt><dd>1</dd><dt>X211</dt><dd>1</dd><dt>X212</dt><dd>1</dd><dt>X213</dt><dd>1</dd><dt>X214</dt><dd>1</dd><dt>X215</dt><dd>1</dd><dt>X216</dt><dd>1</dd><dt>X217</dt><dd>1</dd><dt>X218</dt><dd>1</dd><dt>X219</dt><dd>1</dd><dt>X220</dt><dd>1</dd><dt>X221</dt><dd>1</dd><dt>X222</dt><dd>1</dd><dt>X223</dt><dd>1</dd><dt>X224</dt><dd>1</dd><dt>X225</dt><dd>1</dd><dt>X226</dt><dd>1</dd><dt>X227</dt><dd>1</dd><dt>X228</dt><dd>1</dd><dt>X229</dt><dd>1</dd><dt>X230</dt><dd>1</dd><dt>X231</dt><dd>1</dd><dt>X232</dt><dd>1</dd><dt>X233</dt><dd>1</dd><dt>X234</dt><dd>1</dd><dt>X235</dt><dd>1</dd><dt>X236</dt><dd>1</dd><dt>X237</dt><dd>1</dd><dt>X238</dt><dd>1</dd><dt>PAIN_INTENSITY_AVERAGE</dt><dd>1</dd><dt>PROMIS_PHYSICAL_FUNCTION</dt><dd>1</dd><dt>PROMIS_PAIN_BEHAVIOR</dt><dd>6371</dd><dt>PROMIS_DEPRESSION</dt><dd>88</dd><dt>PROMIS_ANXIETY</dt><dd>88</dd><dt>PROMIS_SLEEP_DISTURB_V1_0</dt><dd>88</dd><dt>PROMIS_PAIN_INTERFERENCE</dt><dd>152</dd><dt>GH_MENTAL_SCORE</dt><dd>2947</dd><dt>GH_PHYSICAL_SCORE</dt><dd>2947</dd><dt>AGE_AT_CONTACT</dt><dd>1</dd><dt>BMI</dt><dd>5633</dd><dt>CCI_TOTAL_SCORE</dt><dd>1</dd><dt>PAIN_INTENSITY_AVERAGE.follow_up</dt><dd>14521</dd><dt>PAT_SEX</dt><dd>1</dd><dt>PAT_RACE</dt><dd>142</dd><dt>CCI_bin</dt><dd>1</dd><dt>medicaid_bin</dt><dd>301</dd><dt>NUM_REGIONS</dt><dd>1</dd><dt>LOWER_BACK</dt><dd>1</dd></dl>



Interestingly, we can see that there is at least one missing value in each column. It might be the case that there is a row with all NA values. Let's apply the same function by row. Taking the maximum, we can see that row 11749 has all NA values.


```R
max(apply(pain, 1, function(x) sum(is.na(x))))
which.max(apply(pain, 1, function(x) sum(is.na(x))))
```


94



11749


We remove that row and then find the percentage of missing values by column. We can see that the column with the highest percentage of missing values is the pain intensity at follow-up. In fact, only 33% of patients have a recorded follow-up visit. 


```R
pain <- pain[-11749,]
apply(pain, 2, function(x) sum(is.na(x))/nrow(pain))
```


<style>
.dl-inline {width: auto; margin:0; padding: 0}
.dl-inline>dt, .dl-inline>dd {float: none; width: auto; display: inline-block}
.dl-inline>dt::after {content: ":\0020"; padding-right: .5ex}
.dl-inline>dt:not(:first-of-type) {padding-left: .5ex}
</style><dl class=dl-inline><dt>PATIENT_NUM</dt><dd>0</dd><dt>X101</dt><dd>0</dd><dt>X102</dt><dd>0</dd><dt>X103</dt><dd>0</dd><dt>X104</dt><dd>0</dd><dt>X105</dt><dd>0</dd><dt>X106</dt><dd>0</dd><dt>X107</dt><dd>0</dd><dt>X108</dt><dd>0</dd><dt>X109</dt><dd>0</dd><dt>X110</dt><dd>0</dd><dt>X111</dt><dd>0</dd><dt>X112</dt><dd>0</dd><dt>X113</dt><dd>0</dd><dt>X114</dt><dd>0</dd><dt>X115</dt><dd>0</dd><dt>X116</dt><dd>0</dd><dt>X117</dt><dd>0</dd><dt>X118</dt><dd>0</dd><dt>X119</dt><dd>0</dd><dt>X120</dt><dd>0</dd><dt>X121</dt><dd>0</dd><dt>X122</dt><dd>0</dd><dt>X123</dt><dd>0</dd><dt>X124</dt><dd>0</dd><dt>X125</dt><dd>0</dd><dt>X126</dt><dd>0</dd><dt>X127</dt><dd>0</dd><dt>X128</dt><dd>0</dd><dt>X129</dt><dd>0</dd><dt>X130</dt><dd>0</dd><dt>X131</dt><dd>0</dd><dt>X132</dt><dd>0</dd><dt>X133</dt><dd>0</dd><dt>X134</dt><dd>0</dd><dt>X135</dt><dd>0</dd><dt>X136</dt><dd>0</dd><dt>X201</dt><dd>0</dd><dt>X202</dt><dd>0</dd><dt>X203</dt><dd>0</dd><dt>X204</dt><dd>0</dd><dt>X205</dt><dd>0</dd><dt>X206</dt><dd>0</dd><dt>X207</dt><dd>0</dd><dt>X208</dt><dd>0</dd><dt>X209</dt><dd>0</dd><dt>X210</dt><dd>0</dd><dt>X211</dt><dd>0</dd><dt>X212</dt><dd>0</dd><dt>X213</dt><dd>0</dd><dt>X214</dt><dd>0</dd><dt>X215</dt><dd>0</dd><dt>X216</dt><dd>0</dd><dt>X217</dt><dd>0</dd><dt>X218</dt><dd>0</dd><dt>X219</dt><dd>0</dd><dt>X220</dt><dd>0</dd><dt>X221</dt><dd>0</dd><dt>X222</dt><dd>0</dd><dt>X223</dt><dd>0</dd><dt>X224</dt><dd>0</dd><dt>X225</dt><dd>0</dd><dt>X226</dt><dd>0</dd><dt>X227</dt><dd>0</dd><dt>X228</dt><dd>0</dd><dt>X229</dt><dd>0</dd><dt>X230</dt><dd>0</dd><dt>X231</dt><dd>0</dd><dt>X232</dt><dd>0</dd><dt>X233</dt><dd>0</dd><dt>X234</dt><dd>0</dd><dt>X235</dt><dd>0</dd><dt>X236</dt><dd>0</dd><dt>X237</dt><dd>0</dd><dt>X238</dt><dd>0</dd><dt>PAIN_INTENSITY_AVERAGE</dt><dd>0</dd><dt>PROMIS_PHYSICAL_FUNCTION</dt><dd>0</dd><dt>PROMIS_PAIN_BEHAVIOR</dt><dd>0.294117647058824</dd><dt>PROMIS_DEPRESSION</dt><dd>0.00401699141194939</dd><dt>PROMIS_ANXIETY</dt><dd>0.00401699141194939</dd><dt>PROMIS_SLEEP_DISTURB_V1_0</dt><dd>0.00401699141194939</dd><dt>PROMIS_PAIN_INTERFERENCE</dt><dd>0.00697201957706159</dd><dt>GH_MENTAL_SCORE</dt><dd>0.136023640225321</dd><dt>GH_PHYSICAL_SCORE</dt><dd>0.136023640225321</dd><dt>AGE_AT_CONTACT</dt><dd>0</dd><dt>BMI</dt><dd>0.260042478529873</dd><dt>CCI_TOTAL_SCORE</dt><dd>0</dd><dt>PAIN_INTENSITY_AVERAGE.follow_up</dt><dd>0.67042201495983</dd><dt>PAT_SEX</dt><dd>0</dd><dt>PAT_RACE</dt><dd>0.00651029642626281</dd><dt>CCI_bin</dt><dd>0</dd><dt>medicaid_bin</dt><dd>0.0138516945239634</dd><dt>NUM_REGIONS</dt><dd>0</dd><dt>LOWER_BACK</dt><dd>0</dd></dl>



We will create two new columns. First, we create a column for the change in pain at follow-up. Second, we create a column which is the percent change in pain at follow-up. 


```R
pain$PAIN_CHANGE <- pain$PAIN_INTENSITY_AVERAGE.follow_up - pain$PAIN_INTENSITY_AVERAGE
hist(pain$PAIN_CHANGE)
```


    
![png](output_57_0.png)
    



```R
pain$PERC_PAIN_CHANGE <- pain$PAIN_CHANGE/pain$PAIN_INTENSITY_AVERAGE
summary(pain$PERC_PAIN_CHANGE)
```


       Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
     -1.000  -0.200   0.000     Inf   0.143     Inf   14520 


In the summary of the percent change, we can see that the maximum value is `Inf`. This is R's representation of infinity. This occurred because some patients have an intial pain score of 0, which creates infinite values when we divide through by this value to find the percent change. We can test whether something is infinite using the `is.infinite` or `is.finite()` functions. This shows that there were three patients with infinite values. The value `-Inf` is used to represent negative infinity.


```R
sum(is.infinite(pain$PERC_PAIN_CHANGE))
```


3


Another special value in R is `NaN`, which stands for "Not a Number". For example, `0/0` will result in a NaN value. We can test for `NaN` values using the `is.nan()` function.


```R
0/0
```


NaN


Looking back at the missing values, there are two useful functions for selecting the complete cases in a data frame. The `na.omit()` function returns the data frame with incomplete cases removed whereas `complete.cases()` returns TRUE/FALSE values for each row indicating whether each row is complete, which we can then use to select the rows with TRUE values. Below, we see both approaches select the same number of rows.


```R
pain_sub1 <- na.omit(pain)
pain_sub2 <- pain[complete.cases(pain),]
dim(pain_sub1)
dim(pain_sub2)
```


<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>2413</li><li>96</li></ol>




<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>2413</li><li>96</li></ol>



## Using Logic to Subset, Summarize, and Transform

Above, we used TRUE/FALSE values to select rows in a data frame. The logic operators in R allow us to expand on this capability to write more complex logic. The operators are given below. 

* `<` less than
* `<=` less than or equal to 
* `>` greater than
*  `>=` greater than or equal to 
* `==` equal to
* `!=` not equal to 
* `a %in% b` a's value is in a vector of values v

The first six operators are a direct comparison between two values and are demonstrated below. 


```R
2 < 2
2 <= 2
3 > 2
3 >= 2
3 != 2
"A" == "B"
```


FALSE



TRUE



TRUE



TRUE



TRUE



FALSE


The operators assume there is a natural ordering or comparison between values. For example, for strings the ordering is alphabetical and for logical operators we use their numeric interpretation (TRUE = 1, FALSE = 0).


```R
"A?" < "B"
TRUE < FALSE
```


TRUE



FALSE


The `%in%` operator is slightly different. This operator checks whether a value is in a set of possible values. Below, we can check whether values are in the set `c(4,1,2)`.


```R
1 %in% c(4,1,2)
c(0,1,5) %in% c(4,1,2)
```


TRUE



<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>FALSE</li><li>TRUE</li><li>FALSE</li></ol>



Additionally, we can combine use the following operators to allow us to negate or combine two. 

* `!x` - the **NOT** operator `!` reverses TRUE/FALSE values 
* `x | y` - the **OR** operator `|` checks whether x or y is equal to TRUE
* `x & y` - the **AND** operator `&` checks whether both x and y are equal to TRUE
* `any(x)` - the **any** function checks whether any value in x is TRUE (equivalent to using an OR operator `|` between all values
* `all(x)` - the **all** function checks whether all values in x are TRUE (equivalent to using an AND operator `&` between all values

Some simple examples for each are below. 


```R
!(2 < 3)
("Alice" < "Bob") | ("Alice" < "Aaron")
("Alice" < "Bob") & ("Alice" < "Aaron")
any(c(FALSE, TRUE, TRUE))
all(c(FALSE, TRUE, TRUE))
```


FALSE



TRUE



FALSE



TRUE



FALSE


Let's demonstrate these operators on the pain data. We first update the Medicaid column. The logic on the left hand side selects those that do or do not have Medicaid and then assigns those values to the new ones. 


```R
pain$medicaid_bin[pain$medicaid_bin == "no"] <- "No Medicaid"
pain$medicaid_bin[pain$medicaid_bin == "yes"] <- "Medicaid"
table(pain$medicaid_bin)
```


    
       Medicaid No Medicaid 
           4601       16757 


Additionally, we could subset the data to those that have follow-up. The not operator `!` will reverse the TRUE/FALSE values returned from the `is.na()` function. Therefore, the new value will be TRUE if the follow-up value is *not* NA.


```R
pain_follow_up <- pain[!is.na(pain$PAIN_INTENSITY_AVERAGE.follow_up),]
```

Earlier we created a column indicating whether a patient has lower back pain. We now use the `any()` function to check whether a patient has general back pain. If at least one of these values is equal to 1 then the function will return TRUE. If we had used the `all()` function instead this would check whether all values are equal to 0, indicating that a patient has pain on their whole back. 


```R
pain$BACK <- any(pain$X208==1, pain$X209==1, pain$X212==1, pain$X213==1, 
                 pain$X218==1, pain$X219==1)
```

### Practice Question:

TODO: question has follow-up and has initial pain at 5 or above.

Last, we look at the column for patient race `PAT_RACE`. The `table()` function shows that most patients are `WHITE` or `BLACK`. Given how few observations are in the other categories, we may want to combine these levels. 


```R
table(pain$PAT_RACE)
```


    
             ALASKA NATIVE        AMERICAN INDIAN                  BLACK 
                         2                     58                   3229 
                   CHINESE               DECLINED               FILIPINO 
                        21                    121                      6 
             GUAM/CHAMORRO               HAWAIIAN         INDIAN (ASIAN) 
                         1                      1                     49 
                  JAPANESE                 KOREAN          NOT SPECIFIED 
                         9                     10                      4 
                     OTHER            OTHER ASIAN OTHER PACIFIC ISLANDER 
                         1                     47                     12 
                VIETNAMESE                  WHITE 
                         6                  17940 


To do so, we can use the `%in%` operator. We first create an Asian, Asian American, or Pacific Islander race category and then create an American Indian or Alaska Native category.


```R
aapi_values <- c("CHINESE", "HAWAIIAN", "INDIAN (ASIAN)", "FILIPINO", "VIETNAMESE", 
                 "JAPANESE", "KOREAN", "GUAM/CHAMORRO", "OTHER ASIAN", 
                 "OTHER PACIFIC ISLANDER")
pain$PAT_RACE[pain$PAT_RACE %in% aapi_values] <- "AAPI"
pain$PAT_RACE[pain$PAT_RACE %in% c("ALASKA NATIVE", "AMERICAN INDIAN")] <- "AI/AN"
table(pain$PAT_RACE)
```


    
             AAPI         AI/AN         BLACK      DECLINED NOT SPECIFIED 
              162            60          3229           121             4 
            OTHER         WHITE 
                1         17940 


### Other Selection Functions

Above we selected using TRUE/FALSE boolean values. Instead, we can also use the `which()` function. This function takes TRUE/FALSE values and returns the index values for all the TRUE values. We use this to treat those with race given as `DECLINED` as not specified.


```R
pain$PAT_RACE[which(pain$PAT_RACE == "DECLINED")] <- "NOT SPECIFIED"
```

Another selection function is the `subset()` function. This function takes in two arguments. The first is the vector, matrix, or data frame to select from and the second is a vector of TRUE/FALSE values to use for row selection. We use this to find the observation with race marked as `OTHER`. We then update this race also be marked as not specified.


```R
subset(pain, pain$PAT_RACE == "OTHER")
```


<table class="dataframe">
<caption>A tibble: 1 × 97</caption>
<thead>
	<tr><th scope=col>PATIENT_NUM</th><th scope=col>X101</th><th scope=col>X102</th><th scope=col>X103</th><th scope=col>X104</th><th scope=col>X105</th><th scope=col>X106</th><th scope=col>X107</th><th scope=col>X108</th><th scope=col>X109</th><th scope=col>⋯</th><th scope=col>PAIN_INTENSITY_AVERAGE.follow_up</th><th scope=col>PAT_SEX</th><th scope=col>PAT_RACE</th><th scope=col>CCI_bin</th><th scope=col>medicaid_bin</th><th scope=col>NUM_REGIONS</th><th scope=col>LOWER_BACK</th><th scope=col>PAIN_CHANGE</th><th scope=col>PERC_PAIN_CHANGE</th><th scope=col>BACK</th></tr>
	<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>⋯</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;lgl&gt;</th></tr>
</thead>
<tbody>
	<tr><td>3588</td><td>1</td><td>1</td><td>1</td><td>0</td><td>1</td><td>1</td><td>1</td><td>0</td><td>0</td><td>⋯</td><td>NA</td><td>female</td><td>OTHER</td><td>No comorbidity</td><td>Medicaid</td><td>34</td><td>1</td><td>NA</td><td>NA</td><td>TRUE</td></tr>
</tbody>
</table>




```R
pain$PAT_RACE[pain$PATIENT_NUM==3588] <- "NOT SPECIFIED"
table(pain$PAT_RACE)
```


    
             AAPI         AI/AN         BLACK NOT SPECIFIED         WHITE 
              162            60          3229           126         17940 


## Recap Video

TODO: outline what would be helpful here?

## Exercises

For these exercises, we will be using the **pain** data.

TODO: Add question: Find those that are NA for both `GH_MENTAL_SCORE` and `GH_PHYSICAL_SCORE`, which are the PROMIS global mental and physical scores. Both have 13.6% of missing values - will see missing for both. Drop these columns. 

1. Find summary statistics for `PROMIS_PHYSICAL_FUNTION` and `PROMIS_ANXIETY` variables and observe the distribution of those patient-reported pain experiences. What striking feature do you notice in the summary? 


```R
## solutions:
#data(pain)

summary(pain$PROMIS_PHYSICAL_FUNCTION)
summary(pain$PROMIS_ANXIETY)
```

2. Create frequency tables about `PAT_SEX` and `PAT_RACE` and tell more information about distributions of demographic characteristics.



```R
table(pain$PAT_SEX)
table(pain$PAT_RACE)
```

3. Create a data frame to describe the total number of patients reported pain for each of bodily pain regions. Then, create another data frame for summary statistics.


```R
colsum <- as.data.frame(colSums(pain[,c(2:75)], na.rm = TRUE))
colsum$colSumValue <- colsum$`colSums(pain[, c(2:75)], na.rm = TRUE)`

colsum_summary <- data.frame(Variable = c("Sum of Columns"),
                             Min =  min(colsum$colSumValue),
                             Median = median(colsum$colSumValue),
                             Mean  = mean(colsum$colSumValue),
                             Max = max(colsum$colSumValue),
                             SD = sd(colsum$colSumValue),
                             Var = var(colsum$colSumValue))
```

4. Calculate the median and interquartile range of the distribution of the total number of painful regions selected for each patient. Write a sentence to explain any interesting observations in the context of this dataset. 


```R
rowsum <- as.data.frame(rowSums(pain[,2:75], na.rm = TRUE))
rowsum$RowSumValue <- rowsum$`rowSums(pain[, 2:75], na.rm = TRUE)`

median(rowsum$RowSumValue)
IQR(rowsum$RowSumValue)
```

5. Assume a reasonable number of painful regions for patients to be 15 and use a `subset()` command to create a trimmed version of the pain dataset called **pain.subset** that only contains data for patients with the total number of painful regions less than 15.


```R
pain$rowsum <- rowsum$RowSumValue
pain.subset <- subset(pain, rowsum <=15)
```

6. Find the distribution of `PAIN_INTENSITY_AVERAGE.follow_up`. And create a column of missing data at this follow up variable.


```R
summary(pain$PAIN_INTENSITY_AVERAGE.follow_up)
hist(pain$PAIN_INTENSITY_AVERAGE.follow_up)

# TODO: do without ifelse
pain$missing_follow_up <- ifelse(is.na(pain$PAIN_INTENSITY_AVERAGE.follow_up)==TRUE,1,0)
```

## TODOs

* Functions with () in text
* Test all on binder
