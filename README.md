# access-cancer-genomic-data
Author: Janahan Gnanachandran
==========================

A command-line tool to access cancer genomic data and analyze mutations and copy number alternations

This is a small tool created as an assignment. The idea is to build a command-line tool which would access cancer genomic data from the Cancer Genomics Data Portal hosted at Memorial Sloan-Kettering Cancer Center at http://www.cbioportal.org and retrieve all mutations and copy number alternations of given genes in a set of Glioblastoma samples (you could change it to your study of interest). Using these information, percentage of mutations and copy number alternations will be calculated.

For mutation data:
  • NaN = no mutation
  • any other string = mutation or comma delimited list, e.g. V216M indicates
a mutation.
For the copy number data:
  • 0 = no change
  • -1 or +1 = single copy of gene is lost or gained (you can ignore these)
  • -2 = both copies of the gene are deleted 
  • +2 = multiple copies of the gene are observed
  • NaN = No copy number information

In the simplest version of the program, the user would execute the program with
up to three genes(could be increased according to the need), and output a simple summary. For example:

TP53 is mutated in 8% of all cases.
TP53 is copy number altered in <1.0% of all cases.
Total % of cases where TP53 is altered by either mutation or copy
number alteration: 8% of all cases.

What I learned from this assignment is wrapping an R-Script using a shell so that it takes arguments from the command line and use it in an R program.

The CGDS-R package was used to retrive the data from the portal

/* Requirements
----------------
1) Latest version(2.12 or higher) of R statistical computing package
2) The CGDS-R package which can be downloaded from http://www.cbioportal.org/public-portal/cgds_r.jsp
3) Unix/Linux/MacOS terminal

/* Installation
----------------
Note that assignment.r has an automated way to install any required packages but the R mirror has to be chosen before any library insatllation. That's why it is insatlled manually
1) Open the R terminal in the current working directory and install the cgds_r package by typing install.packages('cgdsr')
2) In the current working directory unzip the Assignment.tar.gz file using "gunzip -c Assignment.tar.gz | tar xopf -"
2) Both the "assignment.r" and the "execute.sh" MUST be in the same working directory
3) Type "chmod +x execute.sh" to make sure the "execute.sh" is executable. This can be checked by "ls -l" 

/* Run the program
------------------
1) At the terminal type "./execute.sh <space delimited list of genes(upto 3) without any quotes>"
   or "bash execute.sh <space delimited list of genes(upto 3) without any quotes>"

/*Any number genes can be given as argument but only first 3 genes will be chosen for analyses*/
