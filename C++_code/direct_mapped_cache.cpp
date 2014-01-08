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


void simulate(int cache_size, int block_size, int flag_DI, int& hit, int& miss, int& acc){
	unsigned int tag,index,x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/block_size);
	int line= cache_size>>(offset_bit);

	cache_content *cache =new cache_content[line];
	cout<<"cache line:"<<line<<endl;

	for(int j=0;j<line;j++)
		cache[j].v=false;

  FILE * fp;
  //=fopen("test.txt","r");					//read file
  if (flag_DI)
    fp=fopen("DCACHE.txt","r");					//read file
  else
    fp=fopen("ICACHE.txt","r");					//read file
  if (!fp) {
    cout << "fail to open file\n";
    return;
  }

	while(fscanf(fp,"%x",&x)!=EOF){
    acc++;
		//cout<<hex<<x<<" ";
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);
		if(cache[index].v && cache[index].tag==tag){
			cache[index].v=true; 			//hit
      hit++;
		}
		else{
			cache[index].v=true;			//miss
			cache[index].tag=tag;
      miss++;
		}
	}
	fclose(fp);

	delete [] cache;
}

int main(){
	// Let us simulate 4KB cache with 16B blocks
  int type = 0;
  int cache_size = 0;
  int block_size = 0;
  int miss;
  int hit;
  int acc;
  double miss_rate;

  while (cout << "Cache size: " && cin >> cache_size &&
      cout << "Block size: " && cin >> block_size &&
      cout << "1 for DCACHE, 0 for ICACHE: " && cin >> type) {
    hit = 0;
    miss = 0;
    acc = 0;
    simulate(cache_size, block_size, type, hit, miss, acc);
    cout << endl << dec;
    cout << "Access: " << acc << endl;
    cout << "Cache size: " << cache_size << " bits" <<  endl;
    cout << "Block size: " << block_size << " bits" <<endl;
    cout << "miss: " << miss << endl;
    cout << "hit: " << hit << endl;
    miss_rate = (double)miss/(double)(hit+miss);
    cout << "miss rate: " << 100*miss_rate << endl << endl;
  }
}
