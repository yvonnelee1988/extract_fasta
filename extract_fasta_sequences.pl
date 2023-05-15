open FH1, "your_database.fasta" or die;
open FH2, "protein_id_one_in_a_row.txt" or die;
open FN1, ">Protein_List.fasta" or die; 
open FN2, ">Out_Not_Found.txt" or die; 


# read in the target first
print "Indexing Target file...... \n";

while(<FH2>){
	chomp;
	$target_gi{$_}=1;
	#print $_."\n";
}



print "Target file indexed\n";

$k=0;
$j=0;
$n=0;
print "Indexing and searching fasta database....\n";

OUTER:while(<FH1>){
        #chomp $_;
        if(m/^\>/){
        	$i++;
        	$header=$_;
        	#print $header."\n";
        	chomp $_;
        	@header=split/\s/,$_;
        	$temp=substr(shift @header,1);
        	#print @header."\n";
        	$header_left=join(" ",@header,);
        	#print $header_left."\n";
        	@header=$temp;
        	#print $temp."\n";
        
           	$sequence=();
           	#print $sequence."\n";
           INNER:while(<FH1>){
           	   if(m/^\>/ or eof){
           	   	@header_found=();
           	   	$i=();
           	   	foreach $protein(@header){# reiterate for each gi in each fasta header 
           	   		#print FN1 $protein."\n"; 
           	   		@Protein=split/\|/,$protein;
           	   		$gi=$Protein[0];
           	   		#print $gi."\n";
 				if(exists ($target_gi{$gi})){
           	   			$i++;
           	   			$j++;
           	   			push @header_found,$protein;
           	   			delete $target_gi{$gi};
           	   			#$gi_found{$gi}=1; 	
           	   			#print "Found $j gi\n";			
 				}
           	  
           		}
           		if($i>0){
           			$n++;
           			print FN1 ">".join("gi\|",@header_found)." $header_left"."\n".$sequence;
           		}
           		$k++;	
                        if ($k%5000==0){
                       		print $k." Entries Searched!\n";
                       	}
           		redo OUTER;      
                  }else{      # to fetch the FASTA sequence        
                       $sequence=$sequence.$_;
	
                       
                    }
                 }
           }
        }
print "FASTA file indexed!\n";  
print "found $n fasta entries, $j gi entries\n";     

$i_not_found=0;
foreach(keys (%target_gi)){
	 	$i_not_found++;
	 	print FN2 $_."\n";
}
print $i_not_found." gi not found!\n";

        
close FH1;
close FH2;
close FN1;
close FN2;