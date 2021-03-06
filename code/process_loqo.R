sparsity_vec = c(2,50,100,125,150)
sparsity_vec_sparse = c(2,10,20,30,40,50,60,70,80,90,100,125,150)
num_trials = 2

#MANUALLY INPUT THE TIMES OF THE RESULTS HERE
#WE PUT IN EXAMPLES TIMES
#first for el1.out
time_el1.vec = rep(NA,length(sparsity_vec)*num_trials)

files = list.files()
files_el1 = files[grep("loqo_res_.*_el1.out",files)]
for(i in 1:length(files_el1)){
	d = read.table(files_el1[i],sep="\n")
	d2 = as.character(unlist(d))
	
	x = grep("Solve = ",d2)
	time_el1.vec[i] = as.numeric(unlist(strsplit(d2[x],"="))[2])
}

#next for el1sparse.out
time_el1sparse.vec = rep(NA,length(sparsity_vec_sparse)*num_trials)

files_el1sparse = files[grep("loqo_res_.*_el1sparse.out",files)]
for(i in 1:length(files_el1sparse)){
        d = read.table(files_el1sparse[i],sep="\n")
        d2 = as.character(unlist(d))

        x = grep("Solve = ",d2)
        time_el1sparse.vec[i] = as.numeric(unlist(strsplit(d2[x],"="))[2])
}


#####################################################
#no need to edit after this
#####################################################

name_vec = c("el1.csv","el1sparse.csv")
iter_vec = c("0","1")
fix_name = "loqo_res_"

el1_mat = matrix(NA,ncol=2,nrow=length(sparsity_vec)*2)
el1sparse_mat = matrix(NA,ncol=2,nrow=length(sparsity_vec_sparse)*2)
count = 1

i = 1
for(j in sparsity_vec){
    for(k in iter_vec){
      tmp = read.csv(paste(fix_name,j,"_",k,"_",name_vec[i],sep=""),header=FALSE,sep=",")
      
      el1_mat[count,1] = sum(abs(tmp[,1]-tmp[,2]))/j
      el1_mat[count,2] = max(abs(tmp[,1]-tmp[,2]))
      
      count = count+1
    }
}
  
i = 2
count = 1
for(j in sparsity_vec_sparse){
    for(k in iter_vec){
      tmp = read.csv(paste(fix_name,j,"_",k,"_",name_vec[i],sep=""),header=FALSE,sep=",")

      el1sparse_mat[count,1] = sum(abs(tmp[,1]-tmp[,2]))/j
        el1sparse_mat[count,2] = max(abs(tmp[,1]-tmp[,2]))
    
	 count = count+1
    }
}

el1_mat = cbind(rep(sparsity_vec,each=2),time_el1.vec,el1_mat)
el1sparse_mat =  cbind(rep(sparsity_vec_sparse,each=2),time_el1sparse.vec,el1sparse_mat)

write.table(el1_mat, file="res_loqo_el1.csv", row.names=FALSE, col.names=FALSE,sep=",")
write.table(el1sparse_mat, file="res_loqo_el1sparse.csv", row.names=FALSE, col.names=FALSE,sep=",")
