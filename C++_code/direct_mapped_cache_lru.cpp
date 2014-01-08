#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag;
	unsigned int  priority;
//	unsigned int	data[16];
};

const int K=1024;

double log2( double n )
{
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2));
}


void simulate(int cache_size, int block_size, int flag_DI, int& hit, int& miss, int& acc, int& associ){
	unsigned int tag, index, x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/(block_size*associ));
	int line= (cache_size>>(offset_bit))/associ;

	cache_content **cache =new cache_content*[associ];
  for (int i = 0; i < associ; i++){
    cache[i] = new cache_content[line];
  }
	cout<<"cache line:"<<line<<endl;
  cout<<"cache way:" << associ << endl;

	for(int i=0;i<associ;i++)
    for(int j=0;j<line;j++){
      cache[i][j].v=false;
      cache[i][j].priority = 0;
    }

  FILE * fp;
  //=fopen("test.txt","r");					//read file
  if (flag_DI)
    fp=fopen("LU.txt","r");					//read file
  else
    fp=fopen("RADIX.txt","r");					//read file
  if (!fp) {
    cout << "fail to open file\n";
    return;
  }

	while(fscanf(fp,"%x",&x)!=EOF){
    acc++;
		//cout<<hex<<x<<" ";
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);

    int index_way = associ;
    for (int i = 0; i < associ; i++){
      if (cache[i][index].v && cache[i][index].tag == tag)
      {
        index_way = i;
      }
    }

    if (index_way < associ){
      cache[index_way][index].priority = acc;
      hit++;
    }
    else {
      int lru = 0;
      for (int i = 0; i < associ-1; i++){
        if (cache[i][index].v == false){
          lru = i;
          break;
        }
        else if (cache[i+1][index].v == false)
        {
          lru = i+1;
          break;
        }
        else if (cache[i][index].priority > cache[i+1][index].priority)
          lru = i+1;
      }
      cache[lru][index].v = true;
      cache[lru][index].tag = tag;
      cache[lru][index].priority = acc;
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
  int associ;
  double miss_rate;

  //cout << "Input: ";
  while (cout << "Cache size: " && cin >> cache_size &&
      cout << "Block size: " && cin >> block_size &&
      cout << "1 for LU, 0 for RADIX: " && cin >> type &&
      cout << "Way: " && cin >> associ) {
    hit = 0;
    miss = 0;
    acc = 0;
    simulate(cache_size, block_size, type, hit, miss, acc, associ);

    cout << endl << dec;
    cout << "Access: " << acc << endl;
    cout << "Cache size: " << cache_size << " bits" <<  endl;
    cout << "Block size: " << block_size << " bits" <<endl;
    cout << "miss: " << miss << endl;
    cout << "hit: " << hit << endl;
    miss_rate = (double)miss/(double)(hit+miss);
    cout << "miss rate: " << 100*miss_rate << endl << endl;

    //cout << "Input: ";
  }
}
