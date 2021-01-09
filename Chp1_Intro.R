##########################################
# Lattice
# Multivaraite Data Visualization with R
# author: Deepayan Sarkar
##########################################

#************************#
# Chapter 1 Introduction
#************************#

#===============================#
# 1.1 Mutlipannel Conditioning
#===============================#
install.packages("mlmRev")
data(Chem97, package = 'mlmRev')
xtabs(~ score, data = Chem97)
#    0    2    4    6    8   10 
# 3688 3627 4619 5739 6668 6681 
# A-level score is discrete grade with possible values 0, 2, 4, 6, 8

#----------------------------------#
# 1.1.1 A histogram for every group
#----------------------------------#
# Q: whether the final A-level score depends on the 
# average GCSE score?
# == is the dist of A-Level score different for differnt
# values of score?
# popular plot to summarize dist is the histomgram

install.packages("lattice")
library(lattice)

histogram(~ gcsescore | factor(score), data = Chem97)

head(Chem97, 2)

histogram(~ gcsescore | score, data = Chem97)




































