#!/usr/bin/Rscript

# (c) Victor Soria-Carrasco
# victor.soria.carrasco@gmail.com
# Last modified: 06/06/2022 17:31:03

# Description:
# This script calculates PCA and produces PC plots 

# WARNING: Beware this script may need large amounts of memory to run (R code)

# Arguments
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# Order of arguments
# ------------------
#  1.- genotype file (bimbam format with header)
#  2.- populations file (two columns: id, pop) -> used for colouring, and for subsetting
#  3.- output PDF file
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# Path to files
# ------------------------------------------------------------------------------
args <- commandArgs(TRUE)

genofile<-as.character(args[1])
popfile<-as.character(args[2])
outfile<-as.character(args[3])

# Testing
# genofile<-"/stash/lysandra/09_alleleEst/panmictic/variants_panmictic_all.geno.dsv"
# popfile<-"/stash/lysandra/09_alleleEst/pops_localities_west.dsv"
# outfile<-"/stash/lysandra/09_alleleEst/panmictic/all_res/all_populations-PCA.pdf"
# ------------------------------------------------------------------------------

genotypes<-read.table(genofile,header=T, check.names=F)

# A3-sized PDF
pdf(file=outfile,width=16.53,height=11.69, onefile=T)

# Assign colours to populations (will be used for pcs plots)
# ------------------------------------------------------------------------------
populations<-read.table(popfile,header=F,stringsAsFactors=F)
# Add X to names starting with a number (it might be necessary because if pcrcomp does this transformation)
# for (i in 1:length(populations[,1])){
#     if (grepl("^[0-9]", populations[i,1])){
#       populations[i,1]<-paste("X",populations[i,1],sep="")
#     }
# }
pops<-sort(unique(populations[,2]))
# use order of populations in file
# pops<-unique(populations[,2])

colours<-colorRampPalette(c("blue","cyan", "green", "yellow", "orange","red"))(length(pops))
#colours<-rainbow(length(pops))
#  Plot palette
# pie(rep(1,length(colours)),label=pops,col=colours, main="legend for populations")

# table of colours assigned to populations
col.table<-data.frame(colours,pops)
# ------------------------------------------------------------------------------

# Subset genotypes if need be
# ------------------------------------------------------------------------------
cols.sel<-c(colnames(genotypes)[1:4],populations[,1])
genotypes<-genotypes[,which(colnames(genotypes) %in% cols.sel)]
# ------------------------------------------------------------------------------

## PCA on the genotype matrix
# ------------------------------------------------------------------------------
pcg<-prcomp(t(genotypes[,-(1:3)]), center=TRUE, scale=FALSE)
# pcs <- predict(pcg)
pcs<-pcg$x
pcs.col<-unlist(lapply (rownames(pcs), function(x) 
as.character(col.table[col.table[,2]==populations[populations[,1]==as.character(x),][[2]],][[1]])))

# plot summary variance explained by pcs
variances <- apply(pcg$x, 2, var)  
prop.var <- variances / sum(variances)
cum.prop.var<-cumsum(prop.var)
par(mfrow=c(2,1),oma=c(1,1,1,1), mar=c(5, 4, 4, 2) + 0.1)
barplot(prop.var[1:100],
	  main="PCA using genotype matrix - % variance explained by first 100 PCs",
	  ylab="% variance explained", xlab="PC", las=3)
barplot(cum.prop.var[1:100],
	  main="PCA using genotype matrix - cumulative % variance explained by first 100 PCs",
	  ylab="% variance explained", xlab="PC", las=3)
  
# # plot summary PCA - plot pcs that explain > top 1% variance (0.99 quantile)
# top<-quantile(prop.var,0.99)
# npcs<-length(prop.var[prop.var>top])

# plot summary PCA - plot first 4 pcs
npcs<-4
comp <- data.frame(pcg$x[,1:npcs])
par(mfrow=c(1,1),oma=c(1,1,1,1), mar=c(5, 4, 4, 2) + 0.1)
plot(comp, pch=20, col=pcs.col, main="PCA using genotype matrix", oma=c(5,5,5,15))
par(mfrow=c(1,1), oma=c(0,0,0,1), mar=c(0,0,0,0), new=T)
plot(0, 0, type="n", bty="n", xaxt="n", yaxt="n")
legend("right", legend=pops, lty=1, lwd=5, col=colours, bty="n",xpd=T)


# plot each PC with sample names
for (i in 1:(npcs-1)){
par(mfrow=c(1,1),oma=c(1,1,1,10), mar=c(5, 4, 4, 2) + 0.1)
plot(pcs[,i],pcs[,i+1],type="n", main="PCA using genotype matrix", xlab=paste("PC",i,sep=""), ylab=paste("PC",(i+1),sep=""))
text(pcs[,i],pcs[,i+1],labels=rownames(pcs),col=pcs.col,cex=0.5)
# plot legend to the right
par(mfrow=c(1,1), oma=c(0,0,0,1), mar=c(0,0,0,0), new=T)
plot(0, 0, type="n", bty="n", xaxt="n", yaxt="n")
legend("right", legend=pops, lty=1, lwd=10, col=colours, bty="n", xpd=T)
}
# ------------------------------------------------------------------------------
# restore defaults


## PCA on covariance matrix
# ------------------------------------------------------------------------------
## calculate N x N genotype covariance matrix
gmn<-apply(genotypes[,-(1:3)],1,mean)
nids<-ncol(genotypes)-3
nloci<-nrow(genotypes)
gmnmat<-matrix(gmn,nrow=nloci,ncol=nids)
gprime<-genotypes[,-(1:3)]-gmnmat

gcovarmat<-matrix(NA,nrow=nids,ncol=nids)
for(i in 1:nids){
for(j in i:nids){
  if (i==j){
	gcovarmat[i,j]<-cov(gprime[,i],gprime[,j])
  }
  else{
	gcovarmat[i,j]<-cov(gprime[,i],gprime[,j])
	gcovarmat[j,i]<-gcovarmat[i,j]
  }
}
}

## pca on the genotype covariance matrix
pcg<-prcomp(x=gcovarmat,center=TRUE,scale=FALSE)
# pcs <- predict(pcg)
pcs<-pcg$x
rownames(pcs)<-colnames(genotypes[,-(1:3)])
pcs.col<-unlist(lapply (rownames(pcs), function(x) 
as.character(col.table[col.table[,2]==populations[populations[,1]==as.character(x),][[2]],][[1]])))

# plot summary variance explained by pcs
variances <- apply(pcg$x, 2, var)  
prop.var <- variances / sum(variances)
cum.prop.var<-cumsum(prop.var)
par(mfrow=c(2,1),oma=c(1,1,1,1), mar=c(5, 4, 4, 2) + 0.1)
barplot(prop.var[1:100],
	  main="PCA using covariance matrix - % variance explained by first 100 PCs",
	  ylab="% variance explained", xlab="PC", las=3)
barplot(cum.prop.var[1:100],
	  main="PCA using covariance matrix - cumulative % variance explained by first 100 PCs",
	  ylab="% variance explained", xlab="PC", las=3)

# # plot summary PCA - plot pcs that explain > top 1% variance (0.99 quantile)
# top<-quantile(prop.var,0.99)
# npcs<-length(prop.var[prop.var>top])

# plot summary PCA - plot first 4 pcs
npcs<-4
comp <- data.frame(pcg$x[,1:npcs])
par(mfrow=c(1,1),oma=c(1,1,1,1), mar=c(5, 4, 4, 2) + 0.1)
plot(comp, pch=20, col=pcs.col, main="PCA using covariance matrix", oma=c(5,5,5,15))
par(mfrow=c(1,1), oma=c(0,0,0,1), mar=c(0,0,0,0), new=T)
plot(0, 0, type="n", bty="n", xaxt="n", yaxt="n")
legend("right", legend=pops, lty=1, lwd=5, col=colours, bty="n",xpd=T)


# plot each PC with sample names
for (i in 1:(npcs-1)){
par(mfrow=c(1,1),oma=c(1,1,1,10), mar=c(5, 4, 4, 2) + 0.1)
plot(pcs[,i],pcs[,i+1],type="n", main="PCA using covariance matrix", xlab=paste("PC",i,sep=""), ylab=paste("PC",(i+1),sep=""))
text(pcs[,i],pcs[,i+1],labels=rownames(pcs),col=pcs.col,cex=0.5)
# plot legend to the right
par(mfrow=c(1,1), oma=c(0,0,0,1), mar=c(0,0,0,0), new=T)
plot(0, 0, type="n", bty="n", xaxt="n", yaxt="n")
legend("right", legend=pops, lty=1, lwd=10, col=colours, bty="n", xpd=T)
}
# ------------------------------------------------------------------------------

dev.off()
