### R code from vignette source 'BoolNet_package_vignette.Snw'

###################################################
### code chunk number 1: BoolNet_package_vignette.Snw:81-82 (eval = FALSE)
###################################################
## install.packages("BoolNet")


###################################################
### code chunk number 2: BoolNet_package_vignette.Snw:86-87
###################################################
library(BoolNet)


###################################################
### code chunk number 3: BoolNet_package_vignette.Snw:166-167 (eval = FALSE)
###################################################
## cellcycle <- loadNetwork("cellcycle.txt")


###################################################
### code chunk number 4: BoolNet_package_vignette.Snw:172-173
###################################################
data(cellcycle)


###################################################
### code chunk number 5: BoolNet_package_vignette.Snw:222-223
###################################################
data(yeastTimeSeries)


###################################################
### code chunk number 6: BoolNet_package_vignette.Snw:230-231
###################################################
binSeries <- binarizeTimeSeries(yeastTimeSeries)


###################################################
### code chunk number 7: BoolNet_package_vignette.Snw:236-239
###################################################
net <- reconstructNetwork(binSeries$binarizedMeasurements, 
                          method="bestfit", 
                          maxK=4)


###################################################
### code chunk number 8: BoolNet_package_vignette.Snw:245-246
###################################################
net


###################################################
### code chunk number 9: BoolNet_package_vignette.Snw:253-258
###################################################
pdf("wiring1.pdf") 
par(mar = c(1, 1, 1, 1))
set.seed(333)
plotNetworkWiring(net)
dev.off()


###################################################
### code chunk number 10: BoolNet_package_vignette.Snw:260-261 (eval = FALSE)
###################################################
## plotNetworkWiring(net)


###################################################
### code chunk number 11: BoolNet_package_vignette.Snw:275-279
###################################################
net <- reconstructNetwork(binSeries$binarizedMeasurements, 
                          method="bestfit", 
                          maxK=4, 
                          excludedDependencies = list("Sic1" = c("Sic1", "Fkh2")))


###################################################
### code chunk number 12: BoolNet_package_vignette.Snw:281-286
###################################################
pdf("wiring2.pdf") 
par(mar = c(1, 1, 1, 1))
set.seed(442)
plotNetworkWiring(net)
dev.off()


###################################################
### code chunk number 13: BoolNet_package_vignette.Snw:294-297
###################################################
net <- reconstructNetwork(binSeries$binarizedMeasurements, 
method="bestfit", maxK=4)
singleNet <- chooseNetwork(net, c(1,2,3,2))


###################################################
### code chunk number 14: BoolNet_package_vignette.Snw:300-301
###################################################
singleNet


###################################################
### code chunk number 15: BoolNet_package_vignette.Snw:307-308
###################################################
set.seed(3176)


###################################################
### code chunk number 16: BoolNet_package_vignette.Snw:310-314
###################################################
series <- generateTimeSeries(cellcycle, 
                             numSeries=100, 
                             numMeasurements=10, 
                             noiseLevel=0.1)


###################################################
### code chunk number 17: BoolNet_package_vignette.Snw:319-322
###################################################
binSeries <- binarizeTimeSeries(series, method="kmeans")
net <- reconstructNetwork(binSeries$binarizedMeasurements, method="bestfit")
net


###################################################
### code chunk number 18: BoolNet_package_vignette.Snw:328-329
###################################################
set.seed(4463)


###################################################
### code chunk number 19: BoolNet_package_vignette.Snw:331-336
###################################################
series <- generateTimeSeries(cellcycle, 
                             numSeries=10, 
                             numMeasurements=10, 
                             perturbations=1,
                             noiseLevel=0.1)


###################################################
### code chunk number 20: <
###################################################
series$perturbations


###################################################
### code chunk number 21: BoolNet_package_vignette.Snw:347-351
###################################################
perturbations <- series$perturbations
series$perturbations <- NULL

binSeries <- binarizeTimeSeries(series, method="kmeans")


###################################################
### code chunk number 22: BoolNet_package_vignette.Snw:354-358
###################################################
net <- reconstructNetwork(binSeries$binarizedMeasurements, 
                          method="bestfit", 
                          perturbations=perturbations)
net


###################################################
### code chunk number 23: BoolNet_package_vignette.Snw:367-368
###################################################
net <- generateRandomNKNetwork(n=10, k=3)


###################################################
### code chunk number 24: BoolNet_package_vignette.Snw:371-372
###################################################
net <- generateRandomNKNetwork(n=10, k=c(1,2,3,1,3,2,3,2,1,1))


###################################################
### code chunk number 25: BoolNet_package_vignette.Snw:377-378
###################################################
net <- generateRandomNKNetwork(n=20, k=20, topology="scale_free")


###################################################
### code chunk number 26: BoolNet_package_vignette.Snw:382-383
###################################################
net <- generateRandomNKNetwork(n=10, k=3, linkage="lattice")


###################################################
### code chunk number 27: BoolNet_package_vignette.Snw:388-392
###################################################
net <- generateRandomNKNetwork(n=10, 
                               k=3, 
                               functionGeneration="biased", 
                               zeroBias=0.75)


###################################################
### code chunk number 28: BoolNet_package_vignette.Snw:399-407
###################################################
net1 <- generateRandomNKNetwork(n=10, 
                                k=3,
                                functionGeneration=generateCanalyzing, 
                                zeroBias=0.75)
net2 <- generateRandomNKNetwork(n=10, 
                                k=3, 
                                functionGeneration=generateNestedCanalyzing, 
                                zeroBias=0.75)


###################################################
### code chunk number 29: BoolNet_package_vignette.Snw:415-428
###################################################
isMonotone <- function(input, func)
{
  for (i in seq_len(ncol(input)))
  # check each input gene
  {
    groupResults <- split(func, input[,i])
    if (any(groupResults[[1]] < groupResults[[2]]) && 
        any(groupResults[[1]] > groupResults[[2]]))
      # the function is not monotone
      return(FALSE)
  }
  return(TRUE)
}


###################################################
### code chunk number 30: BoolNet_package_vignette.Snw:437-441
###################################################
net <- generateRandomNKNetwork(n=10,
                               k=3, 
                               validationFunction="isMonotone", 
                               failureIterations=1000)


###################################################
### code chunk number 31: BoolNet_package_vignette.Snw:452-454
###################################################
data(cellcycle)
knockedOut <- fixGenes(cellcycle, "CycD", 0)


###################################################
### code chunk number 32: BoolNet_package_vignette.Snw:457-458
###################################################
knockedOut <- fixGenes(cellcycle, 1, 0)


###################################################
### code chunk number 33: BoolNet_package_vignette.Snw:461-462
###################################################
overExpressed <- fixGenes(cellcycle, "CycD", 1)


###################################################
### code chunk number 34: BoolNet_package_vignette.Snw:465-466
###################################################
originalNet <- fixGenes(knockedOut, "CycD", -1)


###################################################
### code chunk number 35: BoolNet_package_vignette.Snw:471-472
###################################################
newNet <- fixGenes(cellcycle, c("CycD","CycE"), c(0,1))


###################################################
### code chunk number 36: BoolNet_package_vignette.Snw:483-485
###################################################
data(cellcycle)
stateTransition(cellcycle, rep(1,10))


###################################################
### code chunk number 37: BoolNet_package_vignette.Snw:489-491
###################################################
path <- getPathToAttractor(cellcycle, rep(0,10))
path


###################################################
### code chunk number 38: BoolNet_package_vignette.Snw:496-500
###################################################
pdf("sequence.pdf")
par(mar = c(1, 4, 2, 1))
plotSequence(sequence=path)
dev.off()


###################################################
### code chunk number 39: BoolNet_package_vignette.Snw:502-503 (eval = FALSE)
###################################################
## plotSequence(sequence=path)


###################################################
### code chunk number 40: BoolNet_package_vignette.Snw:516-517 (eval = FALSE)
###################################################
## sequenceToLaTeX(sequence=path, file="sequence.tex")


###################################################
### code chunk number 41: BoolNet_package_vignette.Snw:522-524
###################################################
startState <- generateState(cellcycle, specs=c("CycD"=1,"CycA"=1))
stateTransition(cellcycle,startState)


###################################################
### code chunk number 42: BoolNet_package_vignette.Snw:531-532
###################################################
data(igf)


###################################################
### code chunk number 43: BoolNet_package_vignette.Snw:537-539
###################################################
startState <- generateState(igf, specs=c("IGF"=1))
stateTransition(igf, startState)


###################################################
### code chunk number 44: BoolNet_package_vignette.Snw:542-543
###################################################
getPathToAttractor(network=igf,state=startState)


###################################################
### code chunk number 45: BoolNet_package_vignette.Snw:548-551
###################################################
startState <- generateState(igf, specs=list("IGF"=c(0,0,1)))

startState


###################################################
### code chunk number 46: BoolNet_package_vignette.Snw:561-565
###################################################
pdf("sequence_igf.pdf")
par(mar = c(1, 9, 2, 1))
plotSequence(network=igf, startState=startState)
dev.off()


###################################################
### code chunk number 47: BoolNet_package_vignette.Snw:567-568 (eval = FALSE)
###################################################
## plotSequence(network=igf, startState=startState)


###################################################
### code chunk number 48: BoolNet_package_vignette.Snw:574-575
###################################################
set.seed(54321)


###################################################
### code chunk number 49: BoolNet_package_vignette.Snw:577-578
###################################################
stateTransition(cellcycle, rep(1,10), type="asynchronous")


###################################################
### code chunk number 50: BoolNet_package_vignette.Snw:584-585
###################################################
set.seed(4321)


###################################################
### code chunk number 51: BoolNet_package_vignette.Snw:587-589
###################################################
stateTransition(cellcycle, rep(1,10), type="asynchronous", 
geneProbabilities=c(0.05,0.05,0.2,0.3,0.05,0.05,0.05,0.05,0.1,0.1))


###################################################
### code chunk number 52: BoolNet_package_vignette.Snw:596-598
###################################################
stateTransition(cellcycle, rep(1,10), type="asynchronous", 
chosenGene="CycE")


###################################################
### code chunk number 53: BoolNet_package_vignette.Snw:602-603
###################################################
set.seed(432)


###################################################
### code chunk number 54: BoolNet_package_vignette.Snw:605-607
###################################################
data(examplePBN)
stateTransition(examplePBN, c(0,1,1), type="probabilistic")


###################################################
### code chunk number 55: BoolNet_package_vignette.Snw:610-612
###################################################
stateTransition(examplePBN, c(0,1,1), type="probabilistic", 
chosenFunctions=c(2,1,2))


###################################################
### code chunk number 56: BoolNet_package_vignette.Snw:630-633 (eval = FALSE)
###################################################
## data(cellcycle)
## attr <- getAttractors(cellcycle)
## attr


###################################################
### code chunk number 57: BoolNet_package_vignette.Snw:636-638
###################################################
attr <- getAttractors(cellcycle)
attr


###################################################
### code chunk number 58: BoolNet_package_vignette.Snw:644-645 (eval = FALSE)
###################################################
## print(attr, activeOnly=TRUE)


###################################################
### code chunk number 59: BoolNet_package_vignette.Snw:648-649
###################################################
print(attr, activeOnly=TRUE)


###################################################
### code chunk number 60: BoolNet_package_vignette.Snw:658-659
###################################################
getAttractorSequence(attr, 2)


###################################################
### code chunk number 61: BoolNet_package_vignette.Snw:666-668 (eval = FALSE)
###################################################
## tt <- getTransitionTable(attr)
## tt


###################################################
### code chunk number 62: BoolNet_package_vignette.Snw:682-683 (eval = FALSE)
###################################################
## getBasinOfAttraction(attr, 1)


###################################################
### code chunk number 63: BoolNet_package_vignette.Snw:688-689 (eval = FALSE)
###################################################
## getStateSummary(attr, c(1,1,1,1,1,1,1,1,1,1))


###################################################
### code chunk number 64: BoolNet_package_vignette.Snw:701-706
###################################################
pdf("stategraph1.pdf")
set.seed(43210)
par(mar=c(1,1,1,1))
plotStateGraph(attr)
dev.off()


###################################################
### code chunk number 65: BoolNet_package_vignette.Snw:708-709 (eval = FALSE)
###################################################
## plotStateGraph(attr)


###################################################
### code chunk number 66: BoolNet_package_vignette.Snw:715-720
###################################################
pdf("piecewisestategraph.pdf")
set.seed(43210)
par(mar=c(1,1,1,1))
plotStateGraph(attr, piecewise=TRUE)
dev.off()


###################################################
### code chunk number 67: BoolNet_package_vignette.Snw:722-723 (eval = FALSE)
###################################################
## plotStateGraph(attr, piecewise=TRUE)


###################################################
### code chunk number 68: BoolNet_package_vignette.Snw:738-739 (eval = FALSE)
###################################################
## attr <- getAttractors(cellcycle, method="random", startStates=100)


###################################################
### code chunk number 69: BoolNet_package_vignette.Snw:743-746 (eval = FALSE)
###################################################
## attr <- getAttractors(cellcycle, 
##                       method="chosen", 
##                       startStates=list(rep(0,10),rep(1,10)))


###################################################
### code chunk number 70: BoolNet_package_vignette.Snw:755-756 (eval = FALSE)
###################################################
## plotAttractors(attr, subset=2)


###################################################
### code chunk number 71: BoolNet_package_vignette.Snw:758-762
###################################################
pdf("attractor1.pdf")
par(mar=c(1,5,1,1))
plotAttractors(attr, subset=2)
dev.off()


###################################################
### code chunk number 72: BoolNet_package_vignette.Snw:765-766 (eval = FALSE)
###################################################
## attractorsToLaTeX(attr, subset=2, file="attractors.tex")


###################################################
### code chunk number 73: BoolNet_package_vignette.Snw:780-784
###################################################
attr <- getAttractors(cellcycle, 
                      type="asynchronous",
                      method="random", 
                      startStates=500)


###################################################
### code chunk number 74: BoolNet_package_vignette.Snw:790-791 (eval = FALSE)
###################################################
## attr


###################################################
### code chunk number 75: BoolNet_package_vignette.Snw:817-822 (eval = FALSE)
###################################################
## attr <- getAttractors(cellcycle, 
##                       type="asynchronous",
##                       method="random", 
##                       startStates=500, 
##                       avoidSelfLoops=FALSE)


###################################################
### code chunk number 76: BoolNet_package_vignette.Snw:837-841
###################################################
pdf("attractor2.pdf")
par(mar=c(1,1,1,1))
plotAttractors(attr, subset=2, mode="graph", drawLabels=FALSE)
dev.off()


###################################################
### code chunk number 77: BoolNet_package_vignette.Snw:843-844 (eval = FALSE)
###################################################
## plotAttractors(attr, subset=2, mode="graph", drawLabels=FALSE)


###################################################
### code chunk number 78: BoolNet_package_vignette.Snw:852-854 (eval = FALSE)
###################################################
## sim <- simulateSymbolicModel(igf)
## sim


###################################################
### code chunk number 79: BoolNet_package_vignette.Snw:857-859
###################################################
sim <- simulateSymbolicModel(igf)
sim


###################################################
### code chunk number 80: BoolNet_package_vignette.Snw:873-881
###################################################
pdf("attractor3.pdf")
par(mar=c(1,5,1,1))
plotAttractors(sim, subset=2)
dev.off()
pdf("stategraph2.pdf")
par(mar=c(1,1,1,1))
plotStateGraph(sim)
dev.off()


###################################################
### code chunk number 81: BoolNet_package_vignette.Snw:883-884 (eval = FALSE)
###################################################
## plotAttractors(sim, subset=2)


###################################################
### code chunk number 82: BoolNet_package_vignette.Snw:887-888 (eval = FALSE)
###################################################
## plotStateGraph(sim)


###################################################
### code chunk number 83: BoolNet_package_vignette.Snw:902-903
###################################################
set.seed(43851)


###################################################
### code chunk number 84: BoolNet_package_vignette.Snw:905-906
###################################################
sim <- simulateSymbolicModel(igf, method="random", startStates=2)


###################################################
### code chunk number 85: BoolNet_package_vignette.Snw:909-910
###################################################
sim$sequences


###################################################
### code chunk number 86: BoolNet_package_vignette.Snw:925-928
###################################################
data(examplePBN)
sim <- markovSimulation(examplePBN)
sim


###################################################
### code chunk number 87: BoolNet_package_vignette.Snw:934-935 (eval = FALSE)
###################################################
## plotPBNTransitions(sim)


###################################################
### code chunk number 88: BoolNet_package_vignette.Snw:937-942
###################################################
pdf("pbntransitions.pdf")
set.seed(4961)
par(mar=c(1,1,1,1))
plotPBNTransitions(sim)
dev.off()


###################################################
### code chunk number 89: BoolNet_package_vignette.Snw:955-960
###################################################
data(cellcycle)
sim <- markovSimulation(cellcycle, 
                        numIterations=1024, 
                        returnTable=FALSE)
sim


###################################################
### code chunk number 90: BoolNet_package_vignette.Snw:969-974
###################################################
sim <- markovSimulation(cellcycle, 
                        numIterations=1024,
                        returnTable=FALSE, 
                        startStates=list(rep(1,10)))
sim


###################################################
### code chunk number 91: BoolNet_package_vignette.Snw:986-987
###################################################
set.seed(3361)


###################################################
### code chunk number 92: BoolNet_package_vignette.Snw:989-994
###################################################
data(cellcycle)
r <- perturbTrajectories(cellcycle, 
                         measure="hamming", 
                         numSamples=100, 
                         flipBits=1)


###################################################
### code chunk number 93: BoolNet_package_vignette.Snw:998-999
###################################################
r$value


###################################################
### code chunk number 94: BoolNet_package_vignette.Snw:1003-1009
###################################################
r <- perturbTrajectories(cellcycle, 
                         measure="sensitivity", 
                         numSamples=100, 
                         flipBits=1, 
                         gene="CycE")
r$value


###################################################
### code chunk number 95: BoolNet_package_vignette.Snw:1014-1019
###################################################
r <- perturbTrajectories(cellcycle, 
                         measure="attractor", 
                         numSamples=100, 
                         flipBits=1)
r$value


###################################################
### code chunk number 96: BoolNet_package_vignette.Snw:1026-1029
###################################################
perturbedNet <- perturbNetwork(cellcycle, 
                               perturb="functions", 
                               method="bitflip")


###################################################
### code chunk number 97: BoolNet_package_vignette.Snw:1034-1037
###################################################
perturbedNet <- perturbNetwork(cellcycle, 
                               perturb="functions", 
                               method="shuffle")


###################################################
### code chunk number 98: BoolNet_package_vignette.Snw:1043-1047
###################################################
perturbedNet <- perturbNetwork(cellcycle, 
                               perturb="transitions", 
                               method="bitflip", 
                               numStates=10)


###################################################
### code chunk number 99: BoolNet_package_vignette.Snw:1055-1111 (eval = FALSE)
###################################################
## # Perform a robustness test on a network
## # by counting the numbers of perturbed networks
## # containing the attractors of the original net
## 
## library(BoolNet)
## 
## # load mammalian cell cycle network
## data(cellcycle)
## 
## # get attractors in original network
## attrs <- getAttractors(cellcycle, canonical=TRUE)
## 
## # create 1000 perturbed copies of the network and search for attractors
## perturbationResults <- sapply(1:1000, function(i)
## {
##   # perturb network and identify attractors
##   perturbedNet <- perturbNetwork(cellcycle, perturb="functions", method="bitflip")
##   perturbedAttrs <- getAttractors(perturbedNet, canonical=TRUE)
##   
##   # check whether the attractors in the original network exist in the perturbed network
##   attractorIndices <- sapply(attrs$attractors,function(attractor1)
##         {
##           index <- which(sapply(perturbedAttrs$attractors, function(attractor2)
##             {
##               identical(attractor1, attractor2)
##             }))
##           if (length(index) == 0)
##             NA
##           else
##             index
##         })
##   return(attractorIndices)
## })
## 
## # perturbationResults now contains a matrix
## # with the first 2 columns specifying the indices or the 
## # original attractors in the perturbed network 
## # (or NA if the attractor was not found) and the next 2 
## # columns counting the numbers of states
## # in the basin of attraction (or NA if the attractor was not found)
## 
## # measure the total numbers of occurrences of the original attractors in the perturbed copies
## numOccurrences <- apply(perturbationResults[seq_along(attrs$attractors),,drop=FALSE], 1,
##                       function(row)sum(!is.na(row)))
## 
## # print original attractors
## cat("Attractors in original network:\n")
## print(attrs)
## 
## # print information
## cat("Number of occurrences of the original attractors",
##   "in 1000 perturbed copies of the network:\n")
## for (i in 1:length(attrs$attractors))
## {
##   cat("Attractor ",i,": ",numOccurrences[i],"\n",sep="")
## }


###################################################
### code chunk number 100: BoolNet_package_vignette.Snw:1145-1150 (eval = FALSE)
###################################################
## data(cellcycle)
## res <- testNetworkProperties(cellcycle, 
##                       numRandomNets=100, 
##                       testFunction="testAttractorRobustness", 
##                       testFunctionParams = list(copies=100, perturb="functions"))


###################################################
### code chunk number 101: BoolNet_package_vignette.Snw:1156-1165
###################################################
pdf("attractor_robustness.pdf")
par(mar=c(4,4,2,1))
data(cellcycle)
set.seed(3241)
res <- testNetworkProperties(cellcycle, 
                      numRandomNets=100, 
                      testFunction="testAttractorRobustness", 
                      testFunctionParams = list(copies=100, perturb="functions"))
dev.off()


###################################################
### code chunk number 102: BoolNet_package_vignette.Snw:1186-1191 (eval = FALSE)
###################################################
## testNetworkProperties(cellcycle, 
##                       numRandomNets=100,
##                       testFunction="testTransitionRobustness",
##                       testFunctionParams=list(numSamples=100),
##                       alternative="less")  


###################################################
### code chunk number 103: BoolNet_package_vignette.Snw:1194-1204
###################################################
pdf("transition_robustness.pdf")
par(mar=c(4,4,2,1))
data(cellcycle)
set.seed(22652)
testNetworkProperties(cellcycle, 
                      numRandomNets=100,
                      testFunction="testTransitionRobustness",
                      testFunctionParams=list(numSamples=100),
                      alternative="less")  
dev.off()


###################################################
### code chunk number 104: BoolNet_package_vignette.Snw:1209-1212 (eval = FALSE)
###################################################
## testNetworkProperties(cellcycle, 
##                       numRandomNets=100, 
##                       testFunction="testIndegree")


###################################################
### code chunk number 105: BoolNet_package_vignette.Snw:1214-1221
###################################################
pdf("indegree.pdf")
par(mar=c(4,4,2,1))
set.seed(6314)
testNetworkProperties(cellcycle, 
                      numRandomNets=100, 
                      testFunction="testIndegree")
dev.off()


###################################################
### code chunk number 106: BoolNet_package_vignette.Snw:1238-1242 (eval = FALSE)
###################################################
## testNetworkProperties(cellcycle, 
##                       numRandomNets=100, 
##                       testFunction="testIndegree", 
##                       accumulation="kullback_leibler")


###################################################
### code chunk number 107: BoolNet_package_vignette.Snw:1244-1252
###################################################
pdf("indegree_kl.pdf")
par(mar=c(4,4,2,1))
set.seed(234256)
testNetworkProperties(cellcycle, 
                      numRandomNets=100, 
                      testFunction="testIndegree", 
                      accumulation="kullback_leibler")
dev.off()


###################################################
### code chunk number 108: BoolNet_package_vignette.Snw:1268-1280
###################################################
testBasinSizes <- function(network, accumulate=TRUE, params)
{
  attr <- getAttractors(network)
  basinSizes <- sapply(attr$attractors, function(a)
                      { 
                         a$basinSize
                      })
   if (accumulate)
     return(mean(basinSizes))
   else
     return(basinSizes)                  
}


###################################################
### code chunk number 109: BoolNet_package_vignette.Snw:1286-1290 (eval = FALSE)
###################################################
## testNetworkProperties(cellcycle, 
##                       numRandomNets=100,
##                       testFunction="testBasinSizes",
##                       xlab="Average size of basins of attraction")


###################################################
### code chunk number 110: BoolNet_package_vignette.Snw:1292-1300
###################################################
pdf("basinsize.pdf")
par(mar=c(4,4,2,1))
set.seed(6724)
testNetworkProperties(cellcycle, 
                      numRandomNets=100,
                      testFunction="testBasinSizes",
                      xlab="Average size of basins of attraction")
dev.off()


###################################################
### code chunk number 111: BoolNet_package_vignette.Snw:1323-1324 (eval = FALSE)
###################################################
## saveNetwork(cellcycle, file="cellcycle.txt")


###################################################
### code chunk number 112: BoolNet_package_vignette.Snw:1329-1331
###################################################
net <- generateRandomNKNetwork(n=10, k=3, readableFunctions=FALSE)
saveNetwork(net, file="randomnet.txt", generateDNF=TRUE)


###################################################
### code chunk number 113: BoolNet_package_vignette.Snw:1346-1349
###################################################
toSBML(cellcycle, file="cellcycle.sbml")
sbml_cellcycle <- loadSBML("cellcycle.sbml")
sbml_cellcycle


###################################################
### code chunk number 114: BoolNet_package_vignette.Snw:1368-1369 (eval = FALSE)
###################################################
## system.file("doc/example.btp", package="BoolNet")


###################################################
### code chunk number 115: BoolNet_package_vignette.Snw:1401-1402
###################################################
net <- loadBioTapestry(system.file("doc/example.btp", package="BoolNet"))


###################################################
### code chunk number 116: BoolNet_package_vignette.Snw:1404-1405 (eval = FALSE)
###################################################
## net <- loadBioTapestry("example.btp")


###################################################
### code chunk number 117: BoolNet_package_vignette.Snw:1410-1411 (eval = FALSE)
###################################################
## net


###################################################
### code chunk number 118: BoolNet_package_vignette.Snw:1434-1435 (eval = FALSE)
###################################################
## plotNetworkWiring(net)


###################################################
### code chunk number 119: BoolNet_package_vignette.Snw:1437-1442
###################################################
pdf("wiring_biotap.pdf")
par(mar=c(1,1,1,1))
set.seed(559652)
plotNetworkWiring(net)
dev.off()


###################################################
### code chunk number 120: BoolNet_package_vignette.Snw:1463-1466 (eval = FALSE)
###################################################
## data(cellcycle)
## attr <- getAttractors(cellcycle)
## toPajek(attr, file="cellcycle.net")


###################################################
### code chunk number 121: BoolNet_package_vignette.Snw:1470-1471 (eval = FALSE)
###################################################
## toPajek(attr, file="cellcycle.net", includeLabels=TRUE)

