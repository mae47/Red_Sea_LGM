####ABC random forest for model end3, C_melanopterus
####script from Yellow_Warbler_Project/code/R_scripts/ABCRandomForest.Rmd

library("abc", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("abcrf", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("ggplot2", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("gridExtra", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("stringr", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("knitr", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")

knitr::opts_chunk$set(echo = TRUE)


#Add 'densityPosterior' function to env.
print("adding plotting function to environment")
densityPosterior.regAbcrf <- 
function(object, obs, training, add=TRUE, main="Posterior density", log="", xlim=NULL, ylim=NULL,
         xlab=NULL, ylab=NULL, paral=FALSE, ncores= if(paral) max(detectCores()-1,1) else 1, ...)
{
    ### Checking arguments
    if (!inherits(object, "regAbcrf")) 
      stop("object not of class regAbcrf")
  
    if (!inherits(training, "data.frame"))
      stop("training needs to be a data.frame object")
  
    if (!inherits(obs, "data.frame")) 
      stop("obs needs to be a data.frame object")
    if (nrow(obs) == 0L || is.null(nrow(obs)))
      stop("no data in obs")
    if (nrow(training) == 0L || is.null(nrow(training)))
      stop("no simulation in the training reference table (response, sumstat)")
    if ( (!is.logical(add)) || (length(add) != 1L) )
      stop("add should be TRUE or FALSE")
    if ( (!is.logical(paral)) || (length(paral) != 1L) )
      stop("paral should be TRUE or FALSE")
    if(is.na(ncores)){
      warning("Unable to automatically detect the number of CPU cores, \n1 CPU core will be used or please specify ncores.")
      ncores <- 1
    }
    if( !is.character(log) )
      stop("log needs to be a character string")
    x <- obs
    if(!is.null(x)){
      if(is.vector(x)){
        x <- matrix(x,ncol=1)
      }
      if (nrow(x) == 0) 
        stop("obs has 0 rows")
      if (any(is.na(x))) 
        stop("missing values in obs")
    }
    
    # resp and sumsta recover
  
    mf <- match.call(expand.dots=FALSE)
    mf <- mf[1]
    mf$formula <- object$formula
    mf$data <- training
    
    training <- mf$data
    
    mf[[1L]] <- as.name("model.frame")
    mf <- eval(mf, parent.frame() )
    mt <- attr(mf, "terms")
    resp <- model.response(mf)
    
    obj <- object$model.rf
    inbag <- matrix(unlist(obj$inbag.counts, use.names=FALSE), ncol=obj$num.trees, byrow=FALSE)
    
    obj[["origNodes"]] <- predict(obj, training, predict.all=TRUE, num.threads=ncores)$predictions
    obj[["origObs"]] <- model.response(mf)
    
    #####################
    origObs <- obj$origObs
    origNodes <- obj$origNodes
    
    nodes <- predict(obj, x, predict.all=TRUE, num.threads=ncores )$predictions
    if(is.null(dim(nodes))) nodes <- matrix(nodes, nrow=1)
    ntree <- obj$num.trees
    nobs <- object$model.rf$num.samples
    nnew <- nrow(x)
    weights <- abcrf:::findweights(origNodes, nodes, inbag, as.integer(nobs), as.integer(nnew), as.integer(ntree)) # cpp function call
    weights.std <- weights/ntree
    
	return(list(resp=resp, weights.std=weights.std))
}



#Improved loop for multiplot ggplot
#List names of environments to load: removed "t01_param_rf_11092023.RData, resize_param_rf_11092023.RData, gr_param_rf_11092023.RData"
print("starting multiplot loop. Loading environments")
#orange 10k Dt sims
#envs <- c("resize_mod_param_rf_11092023_Dt.RData","gr_param_rf_11092023_Dt.RData")
envs <- c("Nsource_param_rf_11092023_Dt.RData","Nanc_param_rf_11092023_Dt.RData","Nbott_param_rf_11092023_Dt.RData","Npop_RS_param_rf_11092023_Dt.RData","Npop_IO_param_rf_11092023_Dt.RData","split_IO_param_rf_11092023_Dt.RData","resize_param_rf_11092023_Dt.RData","resize_mod_param_rf_11092023_Dt.RData","tanc_param_rf_11092023_Dt.RData","tbott_param_rf_11092023_Dt.RData","trec_param_rf_11092023_Dt.RData","tstop_param_rf_11092023_Dt.RData","tleng_param_rf_11092023_Dt.RData","gr_param_rf_11092023_Dt.RData","mig_param_rf_11092023_Dt.RData")
#pink 10k Da sims
#envs2 <- c("resize_mod_param_rf_11092023_Da.RData","gr_param_rf_11092023_Da.RData")
envs2 <- c("Nsource_param_rf_11092023_Da.RData","Nanc_param_rf_11092023_Da.RData","Nbott_param_rf_11092023_Da.RData","Npop_RS_param_rf_11092023_Da.RData","Npop_IO_param_rf_11092023_Da.RData","split_IO_param_rf_11092023_Da.RData","resize_param_rf_11092023_Da.RData","resize_mod_param_rf_11092023_Da.RData","tanc_param_rf_11092023_Da.RData","tbott_param_rf_11092023_Da.RData","trec_param_rf_11092023_Da.RData","tstop_param_rf_11092023_Da.RData","tleng_param_rf_11092023_Da.RData","gr_param_rf_11092023_Da.RData","mig_param_rf_11092023_Da.RData")
#green 10k Pm sims
#envs3 <- c("resize_mod_param_rf_11092023_Pm.RData","gr_param_rf_11092023_Pm.RData")
envs3 <- c("Nsource_param_rf_11092023_Pm.RData","Nanc_param_rf_11092023_Pm.RData","Nbott_param_rf_11092023_Pm.RData","Npop_RS_param_rf_11092023_Pm.RData","Npop_IO_param_rf_11092023_Pm.RData","split_IO_param_rf_11092023_Pm.RData","resize_param_rf_11092023_Pm.RData","resize_mod_param_rf_11092023_Pm.RData","tanc_param_rf_11092023_Pm.RData","tbott_param_rf_11092023_Pm.RData","trec_param_rf_11092023_Pm.RData","tstop_param_rf_11092023_Pm.RData","tleng_param_rf_11092023_Pm.RData","gr_param_rf_11092023_Pm.RData","mig_param_rf_11092023_Pm.RData")
#blue 10k Dm sims
#envs4 <- c("resizebott_param_rf_11092023_Dm.RData","tleng_param_rf_11092023_Dm.RData","mig_param_rf_11092023_Dm.RData")
#envs4 <- c("tanc_param_rf_11092023_Dm.RData","Nanc_param_rf_11092023_Dm.RData","tbott_param_rf_11092023_Dm.RData","Nbott_param_rf_11092023_Dm.RData","resize_param_rf_11092023_Dm.RData","trec_param_rf_11092023_Dm.RData","tleng_param_rf_11092023_Dm.RData","gr_param_rf_11092023_Dm.RData","Npop0_param_rf_11092023_Dm.RData","Npop1_param_rf_11092023_Dm.RData","mig_param_rf_11092023_Dm.RData") NB subset of Dm params...
#blue 10k Cm sims
#envs4 <- c("resize_mod_param_rf_11092023_Cm.RData","gr_param_rf_11092023_Cm.RData")
envs4 <- c("Nsource_param_rf_11092023_Cm.RData","Nanc_param_rf_11092023_Cm.RData","Nbott_param_rf_11092023_Cm.RData","Npop_RS_param_rf_11092023_Cm.RData","Npop_IO_param_rf_11092023_Cm.RData","split_IO_param_rf_11092023_Cm.RData","resize_param_rf_11092023_Cm.RData","resize_mod_param_rf_11092023_Cm.RData","tanc_param_rf_11092023_Cm.RData","tbott_param_rf_11092023_Cm.RData","trec_param_rf_11092023_Cm.RData","tstop_param_rf_11092023_Cm.RData","tleng_param_rf_11092023_Cm.RData","gr_param_rf_11092023_Cm.RData","mig_param_rf_11092023_Cm.RData")

#basic root for these envs
env_path <- "/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/analysis/abcrf_compare/environments/"

#adding to create table for parameter estimation output
for (i in c(1,2,3,4)) {
write.table((matrix(ncol=8, nrow=0)), paste0("/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/analysis/abcrf_compare/output/abcrf_param_est_",i), col.names=c("expectation","med","variance","variance.cdf","quantiles1","quantiles2","post.NMAE.mean","mode")) }

#create a list to store the individual plots
plots<-list()


#looping through all envs
print("looping through all envs")
#k<-1
for (k in 1:length(envs)) {

print(k)
  #cut off rest of env name to get param_name
  param_name <- substr(envs[k],1,nchar(envs[k])-27)
  print(param_name)

  #load envs1
  #build path to env of interest
  load(paste0(env_path, envs[k]))
  #apropos grabs the matching object name from the loaded env 
  target_rf_obj <- apropos("_param_rf")
print("head of target")
print(head(target_rf_obj))
  #get() turns character string to object name
print("calcing param density")
  param_density <- densityPosterior.regAbcrf(get(target_rf_obj), 
                                             obs = obs_summary_stats, 
                                           training = one_param_input)

print(" predict_output_1 ")
predict_output_1<-get(apropos(paste0("predict_output_",param_name)))
predict_output_1<-unlist(predict_output_1)
predict_output_1<-t(predict_output_1)
print(predict_output_1)

  ##load envs2
  load(paste0(env_path, envs2[k]))
  target_rf_obj <- apropos("_param_rf")
  param_density2 <- densityPosterior.regAbcrf(get(target_rf_obj),
					      obs = obs_summary_stats,
					      training = one_param_input)

print(" predict_output_2 ")
predict_output_2<-get(apropos(paste0("predict_output_",param_name)))
predict_output_2<-unlist(predict_output_2)
predict_output_2<-t(predict_output_2)
print(predict_output_2)

  #load envs3
  load(paste0(env_path, envs3[k]))
  target_rf_obj <- apropos("_param_rf")
  param_density3 <- densityPosterior.regAbcrf(get(target_rf_obj),
					      obs = obs_summary_stats,
					      training = one_param_input)  
  
print(" predict_output_3 ")
predict_output_3<-get(apropos(paste0("predict_output_",param_name)))
predict_output_3<-unlist(predict_output_3)
predict_output_3<-t(predict_output_3)
print(predict_output_3)

  #load envs4 Dm NB diff param name for resizebott
#  param_name4 <- substr(envs4[k],1,nchar(envs4[k])-27)
#  print(param_name4)
#  load(paste0(env_path, envs4[k]))
#  target_rf_obj <- apropos(paste0(param_name4,"_param_rf"))
#  param_density4 <- densityPosterior.regAbcrf(get(target_rf_obj),
#						obs = obs_summary_stats,
#						training = one_param_input)
#
#print(" predict_output_4 ")
#predict_output_4<-get(apropos(paste0("predict_output_",param_name4)))
#predict_output_4<-unlist(predict_output_4)
#predict_output_4<-t(predict_output_4)
#print(predict_output_4)


  #load envs4 Cm 
  load(paste0(env_path, envs4[k]))
  target_rf_obj <- apropos("_param_rf")
  param_density4 <- densityPosterior.regAbcrf(get(target_rf_obj),
                                                obs = obs_summary_stats,
                                                training = one_param_input)

print(" predict_output_4 ")
predict_output_4<-get(apropos(paste0("predict_output_",param_name)))
predict_output_4<-unlist(predict_output_4)
predict_output_4<-t(predict_output_4)
print(predict_output_4)
####



  print("get posterior vals")
  post <- data.frame(param = unlist(param_density$resp),
		     postWeight = unlist(param_density$weights.std))
  post_factor <- data.frame(param = 10^(unlist(param_density$resp))/1000, 
                     postWeight = unlist(param_density$weights.std))
  post_mig <- data.frame(param = ((10^(unlist(param_density$resp)))/3)*10000, #to get per year
			postWeight = unlist(param_density$weights.std))
  post_gr <- data.frame(param = (unlist(param_density$resp)/3)*-10000,
			postWeight = unlist(param_density$weights.std))
  post_time <- data.frame(param = (unlist(param_density$resp)*3)/1000,
			postWeight = unlist(param_density$weights.std)) #Dt gen time 3y
  post_tanc <- data.frame(param = ((10^(unlist(param_density$resp)))*3)/1000,
			postWeight = unlist(param_density$weights.std)) 
  ###
  post2 <- data.frame(param = unlist(param_density2$resp),
		      postWeight = unlist(param_density2$weights.std))
  post2_factor <- data.frame(param = 10^(unlist(param_density2$resp))/1000,
			postWeight = unlist(param_density2$weights.std))
  post2_mig <- data.frame(param = ((10^(unlist(param_density2$resp)))/2)*10000, #to get per year
			  postWeight = unlist(param_density2$weights.std))
  post2_gr <- data.frame(param = (unlist(param_density2$resp)/2)*-10000,
			  postWeight = unlist(param_density2$weights.std))
  post2_time <- data.frame(param = (unlist(param_density2$resp)*2)/1000,
			postWeight = unlist(param_density2$weights.std)) #Da gen time 2y
  post2_tanc <- data.frame(param = ((10^(unlist(param_density2$resp)))*2)/1000,
			postWeight = unlist(param_density2$weights.std))
  ###
  post3 <- data.frame(param = unlist(param_density3$resp),
		      postWeight = unlist(param_density3$weights.std))
  post3_factor <- data.frame(param = 10^(unlist(param_density3$resp))/1000,
			postWeight = unlist(param_density3$weights.std))
  post3_mig <- data.frame(param = ((10^(unlist(param_density3$resp)))/4)*10000, #to get per year
			postWeight = unlist(param_density3$weights.std))
  post3_gr <- data.frame(param = (unlist(param_density3$resp)/4)*-10000,
			postWeight = unlist(param_density3$weights.std))
  post3_time <- data.frame(param = (unlist(param_density3$resp)*4)/1000,
		      postWeight = unlist(param_density3$weights.std)) #Pm gen time 4y
  post3_tanc <- data.frame(param = ((10^(unlist(param_density3$resp)))*4)/1000,
			postWeight = unlist(param_density3$weights.std))
  ### Dm
#  post4 <- data.frame(param = unlist(param_density4$resp),
#			postWeight = unlist(param_density4$weights.std))
#  post4_factor <- data.frame(param = unlist(param_density4$resp)/1000,
#			postWeight = unlist(param_density4$weights.std))
#  post4_mig_gr <- data.frame(param = (unlist(param_density4$resp)/2)*10000, #to get per year
#			postWeight = unlist(param_density4$weights.std))
#  post4_time <- data.frame(param = (unlist(param_density4$resp)*2)/1000,
#			postWeight = unlist(param_density4$weights.std)) #Dm gen time 2y
  ###Cm actually post5
  post4 <- data.frame(param = unlist(param_density4$resp),
                      postWeight = unlist(param_density4$weights.std))
  post4_factor <- data.frame(param = 10^(unlist(param_density4$resp))/1000,
                        postWeight = unlist(param_density4$weights.std))
  post4_mig <- data.frame(param = ((10^(unlist(param_density4$resp)))/7)*10000, #to get per year
                          postWeight = unlist(param_density4$weights.std))
  post4_gr <- data.frame(param = (unlist(param_density4$resp)/7)*-10000,
			postWeight = unlist(param_density4$weights.std))
  post4_time <- data.frame(param = (unlist(param_density4$resp)*7)/1000,
                        postWeight = unlist(param_density4$weights.std)) #Cm gen time 7y
  post4_tanc <- data.frame(param = ((10^(unlist(param_density4$resp)))*7)/1000,
			postWeight = unlist(param_density4$weights.std))
  ###




  #make a named object of these values to write out later
  #assign(paste0(param_name,'_Dt_posterior_vals'), post)
  #assign(paste0(param_name,'_Da_posterior_vals'), post2)
  #assign(paste0(param_name,'_Pm_posterior_vals'), post3)
  #assign(paste0(param_name,'_Cm_posterior_vals'), post4)
  
  print("get values for the prior")
  prior_factor <- data.frame(x = 10^(param_density$resp)/1000)
  prior_mig <- data.frame(x = ((10^(param_density$resp))/3)*10000) #prior based on Dt
  prior_gr <- data.frame(x = (param_density$resp/3)*-10000)
  prior <- data.frame(x = param_density$resp)
  prior_time <- data.frame(x = (param_density$resp*3)/1000) #prior based on Dt
  prior_tanc <- data.frame(x = ((10^(param_density$resp))*3)/1000)
  #prior2 <- data.frame(x = param_density2$resp)
  #prior3 <- data.frame(x = param_density3$resp)
  prior4_factor <- data.frame(x = 10^(param_density4$resp)/1000)
  prior4_mig <- data.frame(x = ((10^(param_density4$resp))/7)*10000) #prior based on Cm
  prior4_gr <- data.frame(x = (param_density4$resp/7)*-10000)
  prior4 <- data.frame(x = param_density4$resp)
  prior4_time <- data.frame(x = (param_density4$resp*7)/1000) #prior based on Cm
  prior4_tanc <- data.frame(x = ((10^(param_density4$resp))*7)/1000)

  

  #make a named object of these values to write out later
  #assign(paste0(param_name,'_DtDa_prior_vals'), prior)
  #assign(paste0(param_name,'_Pm_prior_vals'), prior4)
  
  
  
#  if this is a logged value all post and priors are adjusted /1000 for a clearer scale
	if (str_sub(param_name, end=1) == 'N') {
	  cat(param_name, "is logged in plot")

		print("adjusting predict_output for real pop sizes rather than exponent")
		predict_output_1 <- 10^(predict_output_1)
		print(predict_output_1)
		predict_output_2 <- 10^(predict_output_2)
		print(predict_output_2)
		predict_output_3 <- 10^(predict_output_3)
		print(predict_output_3)
		predict_output_4 <- 10^(predict_output_4)
		print(predict_output_4)
	  
    p<- ggplot() +  
	geom_density(data = post_factor, aes(x = param, weight = postWeight), 
                        adjust = 3, color = "#E69F00") + 
	geom_density(data = post2_factor, aes(x = param, weight = postWeight),
		 adjust = 3, color = "#CC79A7") +    
	geom_density(data = post3_factor, aes(x = param, weight = postWeight),
		     adjust = 3, color = "#009E73") +
	geom_density(data = post4_factor, aes(x = param, weight = postWeight),
		    adjust = 3, color = "#00A5FF") +
	geom_density(data = prior_factor, aes(x=x), color = 'grey') +
	geom_density(data = prior4_factor, aes(x=x), color = 'black') +
	   theme(panel.border = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "darkgrey")) + 
    #coord_cartesian() removes added-space between axis bars and plot
    coord_cartesian(expand = FALSE) +
  	scale_x_continuous(trans='log10') + labs(x=expr(paste(!!param_name," x ",10^3," (#ind.; logged)")))
  
    plots[[param_name]]<-p

    print("getting mode") 
    #very important - order of geom_density lines above, need to match 1,2,3 below for the 3 species ymax and corresponding x ie peak. No. 5 would be grey teleost prior, for example
    p2<-p + scale_x_log10()
    p2_data<-ggplot_build(p2)
for (i in c(1,2,3,4)) {
    ymax<-p2_data$data[[i]][which.max(p2_data$data[[i]][,"ymax"]),"ymax"]
    mymode<-p2_data$data[[i]][which.max(p2_data$data[[i]][,"ymax"]),"x"]
    assign(paste0("mymode_",i), (10^mymode)*1000) #very important - scale is logged(log10) so need to adjust mode from plot to non-logged to match non-logged predict_output
   

  }  }
 

#resize doesn't have to be adjusted for generation time or by a factor of 10 because it is a ratio of pop sizes. Also didnt include prior, as wasnt selected from a range. x axis logged
  else if (str_sub(param_name, end=6) == "resize" || str_sub(param_name, end=5) == "split") {
          cat(param_name, "is a resize param")


  p<- ggplot() +
        geom_density(data = post, aes(x = param, weight = postWeight),
                               adjust = 3, color = "#E69F00") +
        geom_density(data = post2, aes(x = param, weight = postWeight),
                             adjust = 3, color = "#CC79A7") +
        geom_density(data = post3, aes(x = param, weight = postWeight),
                             adjust = 3, color = "#009E73") +
        geom_density(data = post4, aes(x = param, weight = postWeight),
                           adjust = 3, color = "#00A5FF") +
	#geom_density(data = prior, aes(x = x), color = 'grey') +
        theme(panel.border = element_blank(), panel.background = element_blank(),
        axis.line = element_line(colour = "darkgrey")) + coord_cartesian(expand = FALSE) +
        labs(x=expr(paste(!!param_name," (Before/After; logged)"))) +
        scale_x_continuous(trans='log10')

        plots[[param_name]]<-p

    print("getting mode")
    #very important - order of geom_density lines above, need to match 1,2,3 below for the 3 species ymax and corresponding x ie peak. No. 5 would be grey teleost prior, for example
    p2<-p + scale_x_log10()
    p2_data<-ggplot_build(p2)
for (i in c(1,2,3,4)) {
    ymax<-p2_data$data[[i]][which.max(p2_data$data[[i]][,"ymax"]),"ymax"]
    mymode<-p2_data$data[[i]][which.max(p2_data$data[[i]][,"ymax"]),"x"]
    assign(paste0("mymode_",i), 10^mymode) #very important - scale is logged(log10) so need to adjust mode from plot to non-logged to match non-logged predict_output
   

  }   }




#tanc, time of initial split, Pm has to be adjusted for generation time (*3), x axis logged. In years before present.

  else if (str_sub(param_name, end=4) == 'tanc') {
	  cat(param_name, "is logged in plot")

	  #adjusting table values for gen times
	  print("adjusted predict_output values for real tanc vals rather than exponents, and for gen times")
	  predict_output_1 <- (10^(predict_output_1))*3 #Dt
	  print(predict_output_1)
	  predict_output_2 <- (10^(predict_output_2))*2 #Da
	  print(predict_output_2)
	  predict_output_3 <- (10^(predict_output_3))*4 #Pm
	  print(predict_output_3)
#	  predict_output_4 <- predict_output_4*2 #Dm
 #	  print(predict_output_4)
	  predict_output_4 <- (10^(predict_output_4))*7 #Cm
          print(predict_output_4)
 


  p<- ggplot() +
	  geom_density(data = post_tanc, aes(x = param, weight = postWeight),
		       adjust = 3, color = '#E69F00') +
	geom_density(data = post2_tanc, aes(x = param, weight = postWeight),
		     adjust = 3, color = '#CC79A7') +
	geom_density(data = post3_tanc, aes(x = param, weight = postWeight),
		     adjust = 3, color = '#009E73') +
	geom_density(data = post4_tanc, aes(x = param, weight = postWeight),
	 	    adjust = 3, color = '#00A5FF') +
	geom_density(data = prior_tanc, aes(x=x), color = 'grey') +
	geom_density(data = prior4_tanc, aes(x=x), color = 'black') +
		theme(panel.border = element_blank(), panel.background = element_blank(),
	axis.line = element_line(colour = "darkgrey")) + 
	labs(x=expr(paste(!!param_name," x ",10^3," (years bp; logged)"))) + coord_cartesian(expand = FALSE) +
	scale_x_continuous(trans='log10')

	plots[[param_name]]<-p


   print("getting mode")
    #very important - order of geom_density lines above, need to match 1,2,3 below for the 3 species ymax and corresponding x ie peak. No. 5 would be grey teleost prior, for example
    p2<-p + scale_x_log10()
    p2_data<-ggplot_build(p2)
for (i in c(1,2,3,4)) {
    ymax<-p2_data$data[[i]][which.max(p2_data$data[[i]][,"ymax"]),"ymax"]
    mymode<-p2_data$data[[i]][which.max(p2_data$data[[i]][,"ymax"]),"x"]
    assign(paste0("mymode_",i), (10^mymode)*1000) #very important - scale is logged(log10) so need to adjust mode from plot to non-logged to match non-logged predict_output 

	
  }  }




#tleng, length of recovery, Pm has to be adjusted for generation time (*3) but not needed logging. In years as opposed to years before present.

  else if (str_sub(param_name, end=5) == 'tleng') {
          cat(param_name, "is tleng")

          #adjusting table values for gen times
          print("adjusted predict_output values for gen times")
          predict_output_1 <- predict_output_1*3 #Dt
          print(predict_output_1)
          predict_output_2 <- predict_output_2*2 #Da
          print(predict_output_2)
          predict_output_3 <- predict_output_3*4 #Pm
          print(predict_output_3)
#	  predict_output_4 <- predict_output_4*2 #Dm
#	  print(predict_output_4)
	  predict_output_4 <- predict_output_4*7 #Cm
          print(predict_output_4)



  p<- ggplot() +
          geom_density(data = post_time, aes(x = param, weight = postWeight),
                       adjust = 3, color = '#E69F00') +
        geom_density(data = post2_time, aes(x = param, weight = postWeight),
                     adjust = 3, color = '#CC79A7') +
        geom_density(data = post3_time, aes(x = param, weight = postWeight),
                     adjust = 3, color = '#009E73') +
	geom_density(data = post4_time, aes(x = param, weight = postWeight),
		     adjust = 3, color = '#00A5FF') +
        geom_density(data = prior_time, aes(x=x), color = 'grey') +
	geom_density(data = prior4_time, aes(x=x), color = 'black') +
                theme(panel.border = element_blank(), panel.background = element_blank(),
        axis.line = element_line(colour = "darkgrey")) + labs(x=expr(paste(!!param_name," x ",10^3," (years)")))

        plots[[param_name]]<-p

        print("getting mode")
        p_data<-ggplot_build(p)
for (i in c(1,2,3,4)) {
        ymax<-p_data$data[[i]][which.max(p_data$data[[i]][,"ymax"]),"ymax"]
        assign(paste0("mymode_",i), (p_data$data[[i]][which.max(p_data$data[[i]][,"ymax"]),"x"])*1000)
   

  }    }





  #if trec or tbott parameter, Pm also has to be adjusted for generation time (*3) but not needed logging. In years before present
  else if (str_sub(param_name, end=1) == 't')  {
	  cat(param_name, "is a timing parameter")


	#adjusting table values for gen times
	print("adjusted table values for gen times")
	predict_output_1 <- predict_output_1*3 #Dt
	print(predict_output_1)
	predict_output_2 <- predict_output_2*2 #Da
	print(predict_output_2)
	predict_output_3 <- predict_output_3*4 #Pm
	print(predict_output_3)
#	predict_output_4 <- predict_output_4*2 #Dm
#	print(predict_output_4)
	predict_output_4 <- predict_output_4*7 #Cm
        print(predict_output_4)

	  
  p<- ggplot() +
	  geom_density(data = post_time, aes(x = param, weight = postWeight),
		       adjust = 3, color = '#E69F00') +
	geom_density(data = post2_time, aes(x = param, weight = postWeight),
		     adjust = 3, color = '#CC79A7') +
	geom_density(data = post3_time, aes(x = param, weight = postWeight),
		     adjust = 3, color = '#009E73') +
	geom_density(data = post4_time, aes(x = param, weight = postWeight),
		     adjust = 3, color = '#00A5FF') +
	geom_density(data = prior_time, aes(x=x), color = 'grey') +
	geom_density(data = prior4_time, aes(x=x), color = 'black') +
		theme(panel.border = element_blank(), panel.background = element_blank(), 
	axis.line = element_line(colour = "darkgrey")) + labs(x=expr(paste(!!param_name," x ",10^3," (years bp)")))

	plots[[param_name]]<-p


	print("getting mode")
        p_data<-ggplot_build(p)
for (i in c(1,2,3,4)) {
        ymax<-p_data$data[[i]][which.max(p_data$data[[i]][,"ymax"]),"ymax"]
        assign(paste0("mymode_",i), (p_data$data[[i]][which.max(p_data$data[[i]][,"ymax"]),"x"])*1000)


	
  } }
  


  #growth rate includes a division by tleng, so also has to be adjusted for generation time (/3 as divider should have been 3x bigger)
  else if (str_sub(param_name, end=2) == 'gr') {
	  cat(param_name, "is gr")

	#adjusting table values for gen times
	print("adjusted predict_output values for gen times")
	predict_output_1 <- predict_output_1/3*-1 #Dt
	print(predict_output_1)
	predict_output_2 <- predict_output_2/2*-1 #Da
	print(predict_output_2)
	predict_output_3 <- predict_output_3/4*-1 #Pm
	print(predict_output_3)
#	predict_output_4 <- predict_output_4/2 #Dm
#	print(predict_output_4)
	predict_output_4 <- predict_output_4/7*-1 #Cm
        print(predict_output_4)


 p<- ggplot() +
	  geom_density(data = post_gr, aes(x = param, weight = postWeight),
		       adjust = 3, color = '#E69F00') +
	geom_density(data = post2_gr, aes(x = param, weight = postWeight),
		     adjust = 3, color = '#CC79A7') +
	geom_density(data = post3_gr, aes(x = param, weight = postWeight),
		     adjust = 3, color = '#009E73') +
	geom_density(data = post4_gr, aes(x = param, weight = postWeight),
		    adjust = 3, color = '#00A5FF') +
	#geom_density(data=prior_gr, aes(x = x), color = 'grey') +
		theme(panel.border = element_blank(), panel.background = element_blank(),
	axis.line = element_line(colour = "darkgrey")) +
	labs(x=expr(paste(!!param_name," x ",10^-4," (log ratio, per year)"))) +
	scale_x_continuous(limits=c(0,8))
	#scale_x_continuous(trans='log10')

	plots[[param_name]]<-p

	print("getting mode")
        p_data<-ggplot_build(p)
for (i in c(1,2,3,4)) {
        ymax<-p_data$data[[i]][which.max(p_data$data[[i]][,"ymax"]),"ymax"]
        assign(paste0("mymode_",i), (p_data$data[[i]][which.max(p_data$data[[i]][,"ymax"]),"x"])*(10^-4))


	
 }  }




  #migration rate is in generations, need to adjust for gen times
  else if (str_sub(param_name, end=3) == 'mig') {
	  cat(param_name, "is logged")

	#adjusting for generation times
	print("adjusting predict_output for real mig sizes rather than exponent, and for gen times")
	predict_output_1 <- (10^(predict_output_1))/3 #Dt
	print(predict_output_1)
	predict_output_2 <- (10^(predict_output_2))/2 #Da
	print(predict_output_2)
	predict_output_3 <- (10^(predict_output_3))/4 #Pm
	print(predict_output_3)
#	predict_output_4 <- predict_output_4/2 #Dm
#	print(predict_output_4)
	predict_output_4 <- (10^(predict_output_4))/7 #Cm
        print(predict_output_4)


  p<- ggplot() +  
           geom_density(data = post_mig, aes(x = param, weight = postWeight), 
                        adjust = 3, color = '#E69F00') + 
	geom_density(data = post2_mig, aes(x = param, weight = postWeight),
			 adjust = 3, color = '#CC79A7') +
	geom_density(data = post3_mig, aes(x = param, weight = postWeight),
		     	adjust = 3, color = '#009E73') +
	geom_density(data = post4_mig, aes(x = param, weight = postWeight),
			adjust = 3, color = '#00A5FF') +
	geom_density(data = prior_mig, aes(x=x), color = 'grey') +
	geom_density(data = prior4_mig, aes(x=x), color = 'black') +
	   theme(panel.border = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "darkgrey")) + 
	labs(x=expr(paste(!!param_name," x ",10^-4," (prop. per year; logged)"))) +
	scale_x_continuous(trans='log10')
	

	plots[[param_name]]<-p


	print("getting mode")
    #very important - order of geom_density lines above, need to match 1,2,3 below for the 3 species ymax and corresponding x ie peak. No. 5 would be grey teleost prior, for example
    p2<-p + scale_x_log10()
    p2_data<-ggplot_build(p2)
for (i in c(1,2,3,4)) {
    ymax<-p2_data$data[[i]][which.max(p2_data$data[[i]][,"ymax"]),"ymax"]
    mymode<-p2_data$data[[i]][which.max(p2_data$data[[i]][,"ymax"]),"x"]
    assign(paste0("mymode_",i), (10^mymode)*(10^-4)) #very important - scale is logged(log10) so need to adjust mode from plot to non-logged to match non-logged predict_output
 

  }   }  




  else {
  cat(param_name, " doesn't fit any of the above categories")
  }


 	#add parameter estimation to created table
print("adding param to table")
for (i in c(1,2,3,4)) {
	assign(paste0("predict_output_",i), cbind(get(paste0("predict_output_",i)), get(paste0("mymode_",i))))
	write.table(get(paste0("predict_output_",i)), paste0("/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/analysis/abcrf_compare/output/abcrf_param_est_",i), append=T, col.names=FALSE, row.names=FALSE) }



  #list of objects that arent needed any more 
print("removing objects")
  remove_list <- c("post_mig","post_gr","post_factor","post_time","post_tanc","post","post2_mig","post2_gr","post2_factor","post2_time","post2_tanc","post2","post3_mig","post3_gr","post3_factor","post3_time","post3_tanc","post3","post4_mig","post4_gr","post4_factor","post4_time","post4_tanc","post4","prior_mig","prior_gr","prior_factor","prior_time","prior_tanc","prior","prior4_mig","prior4_gr","prior4_factor","prior4_time","prior4_tanc","prior4",apropos("_param_rf"),apropos("predict_output_"),apropos("mymode_"))
  #remove_list <- c("post_mig_gr","post_factor","post_time","post","post2_mig_gr","post2_factor","post2_time","post2","prior_mig_gr","prior_factor","prior_time","prior","prior2_mig_gr","prior2_factor","prior2_time","prior2",apropos("_param_rf"),apropos("predict_output_"))
  #remove for clarity/space
  rm(list = remove_list)

 }   #end of for loop for k, all environments

print("printing warnings from all environments. Likely from 'gr' x-axis limit")
print(warnings())
#finished loop. Plot in a 3 by 2 layout
#print("finished loop. Plot multiplot")
#grid.arrange(grobs=plots, nrow=4, ncol=3)

print("saving multiplot")
margin = theme(plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"))
g<-arrangeGrob(grobs=lapply(plots,"+",margin), nrow=5, ncol=3)
#g<-arrangeGrob(plots$tanc, plots$Nanc_logged, plots$tbott, plots$Nbott_logged, plots$trec, plots$tleng, plots$mig, plots$Npop0_logged, plots$Npop1_logged, nrow=3, ncol=3) #removed plots$t01 plots$resize plots$gr
ggsave(file="/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/analysis/abcrf_compare/output/multiplot.pdf", g, width=10, height=10)


#add row names to abcf_param_est table (ie parameter names)
for (i in c(1,2,3,4)) {
abcrf_param_est <- read.table(paste0("/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/analysis/abcrf_compare/output/abcrf_param_est_",i), header=T)
#param_name_list <- c("resize_mod","gr")
param_name_list <- c("Nsource", "Nanc", "Nbott", "Npop_RS", "Npop_IO", "split_IO", "resize", "resize_mod", "tanc", "tbott", "trec", "tstop", "tleng", "gr", "mig") #NB no longer just a subset of params..
param_name_list  <- data.frame(param_name_list)
abcrf_param_est <- cbind(param_name_list, abcrf_param_est)
write.table(abcrf_param_est, paste0("/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/analysis/abcrf_compare/output/abcrf_param_est_",i), row.names=FALSE) }

setwd("/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/analysis/abcrf_compare/output")
file.rename("abcrf_param_est_1","abcrf_param_est_Dt")
file.rename("abcrf_param_est_2","abcrf_param_est_Da")
file.rename("abcrf_param_est_3","abcrf_param_est_Pm")
#file.rename("abcrf_param_est_4","abcrf_param_est_Dm")
file.rename("abcrf_param_est_4","abcrf_param_est_Cm")





print("end of script!")
###end of script

