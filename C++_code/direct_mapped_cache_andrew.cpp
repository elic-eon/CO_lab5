#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag;
//	unsigned int	data[16];
};

const int K=1024;

double log2( double n )
{
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2));
}


double simulate(int cache_size, int block_size){
	unsigned int tag,index,x;
    double hit=0,miss=0;
    double rate=0;
	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/block_size);
	int line= cache_size>>(offset_bit);
    cout<<offset_bit<<" "<<index_bit<<" "<<line<<endl;
	cache_content *cache =new cache_content[line];
	cout<<"cache line:"<<line<<endl;

	for(int j=0;j<line;j++)
		cache[j].v=false;

  FILE * fp=fopen("ICACHE.txt","r");					//read file

	while(fscanf(fp,"%x",&x)!=EOF){
		cout<<hex<<x<<" ";
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);
		if(cache[index].v && cache[index].tag==tag){
			cache[index].v=true;
			hit=hit+1; 			//hit
		}
		else{
			cache[index].v=true;			//miss
			cache[index].tag=tag;
			miss=miss+1;
		}
	}
	fclose(fp);
	rate=miss/(hit+miss);
	cout<<"fuck "<<hit<<" "<<miss<<" "<<rate<<endl;

	delete [] cache;
	return rate;
}

int main(){
    double rate=0;
	// Let us simulate 4KB cache with 16B blocks
	rate=simulate(64,8);
	cout<<rate<<endl;
}
