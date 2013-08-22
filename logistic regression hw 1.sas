ods html;
ods listing close;

LIBNAME fluimp EXCEL PATH="C:\Users\Holly\Documents\Fall Logistic Regression\fludata.xlsx";

/* Copy the data to a data set in the work library */
DATA flu;
    SET fluimp."Sheet1$"n;
RUN;

/* Clear the libref so that we don't mess up the original data */
LIBNAME fluimp CLEAR;

/* VARIABLES in Work.flu

Flu        Yes for the presence of new strain, No otherwise
Age        Age in years of participant in study
Distance  Distance (in miles) to closest hospital
Gender      Gender of participant recorded as Male and Female
Income      Income level of participant recorded as Low, Medium, High
Previous  If the patient had the flu in the last 3 years recorded as Yes and No
Race    Race of patient recorded as Caucasian, AfricanAmerican, Hispanic, Other
Visits    Number of annual visits to doctor’s office
*/

/* Create a contingency table that compares the variables Flu and Gender. 
What is the odds ratio for the relationship between these two variables? 
Is this a significant relationship? */

PROC FREQ DATA=flu NLEVELS;
   TABLES flu*gender / CHISQ MEASURES plots(only)=freqplot 
                              (type=barchart scale=percent orient=vertical twoway=stacked);
RUN;
ods listing;
/* 
               Type of Study                   Value       95% Confidence Limits
               ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
               Case-Control (Odds Ratio)      2.6005        1.6401        4.1234
               Cohort (Col1 Risk)             1.5882        1.2409        2.0328
               Cohort (Col2 Risk)             0.6107        0.4875        0.7650

                                       Sample Size = 347
*/




/* Calculate the appropriate statistic to detect an association between 
the variables Income and Flu and summarize your results in terms of the problem. */


PROC FREQ DATA=flu NLEVELS;
   TABLES income*flu / CHISQ MEASURES plots(only)=freqplot 
                              (type=barchart scale=percent orient=vertical twoway=stacked);
RUN; 

/* These are the p-values that we should use for significance:

|Evidence   |30   |50    |100   |1000   |10,000 |100,000 
| --------- | --- | ---- | ---- | ----- | ----- | ------ 
|Weak       |0.076|0.053 |0.032 |0.009  |0.002  |0.007   
|Positive   |0.028|0.019 |0.010 |0.003  |0.0008 |0.002   
|Strong     |0.005|0.003 |0.001 |0.0003 |0.0001 |0.00003 
|Very Strong|0.001|0.0005|0.0001|0.00004|0.00001|0.000004


                             Statistics for Table of Income by Flu

                    Statistic                     DF       Value      Prob
                    ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
                    Chi-Square                     2      7.6926    0.0214
                    Likelihood Ratio Chi-Square    2      7.9254    0.0190
                    Mantel-Haenszel Chi-Square     1      7.2626    0.0070
                    Phi Coefficient                       0.1489
                    Contingency Coefficient               0.1473
                    Cramer's V                            0.1489
*/



/* Calculate the appropriate statistic to measure the strength of an association 
between the variables Income and Flu and summarize your results in terms of the problem. */

/*  Use same output as above code
    Spearman Correlation                  0.1488    0.0508
*/




/* Conduct a stratified analysis on Gender and Flu controlling for Income. 
Calculate the adjusted (common) odds ratio and compare this to your previous results. 
Does there appear to be a problem with confounding? */

PROC FREQ DATA=flu NLEVELS;
   TABLES income*flu*gender / all plots(only)=oddsratioplot(stats);
RUN; 

/*             Cochran-Mantel-Haenszel Statistics (Based on Table Scores)

                Statistic    Alternative Hypothesis    DF       Value      Prob
                ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
                    1        Nonzero Correlation        1     15.7453    <.0001



                       Estimates of the Common Relative Risk (Row1/Row2)

           Type of Study     Method                  Value     95% Confidence Limits
           ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
           Case-Control      Mantel-Haenszel        2.5214       1.5875       4.0047


*/




/* Conduct a stratified analysis on Gender and Flu controlling for Income. 
Is there a potential problem with quasi-complete separation in the data if we were 
to include an interaction between Gender and Income? */



/* Conduct a stratified analysis on Gender and Flu controlling for Income. 
Calculate the Tyrone’s adjustment for the Breslow-Day statistic and calculate Zelen’s exact test.
From these tests, is there any evidence of interaction between Income and Gender? */


/* Fit a logistic regression model using the above mentioned data set
with Flu as the response variable. Model the probability of having the flu with 
the remaining variables as predictor variables. Use all of the predictor variables 
regardless of your results above. Use effects coding for the Race variable with Other 
as the reference level. Use reference coding for the Income variable with High as the 
reference level. Use reference coding for the Gender variable with Female as the reference level.
Use reference coding for the Previous variable with No as the reference level. */



