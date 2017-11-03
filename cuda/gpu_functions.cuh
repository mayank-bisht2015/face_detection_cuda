__global__ void
gpu_function_1(){
	int x, y, s, sq, t, tq;
  unsigned char it;
  int height = src->height;
  int width = src->width;
  unsigned char *data = src->data;
  int * sumData = sum->data;
  int * sqsumData = sqsum->data;
  for( y = 0; y < height; y++)
    {
      s = 0;
      sq = 0;
      /* loop over the number of columns */
      for( x = 0; x < width; x ++)
	{
	  it = data[y*width+x];
	  /* sum of the current row (integer)*/
	  s += it; 
	  sq += it*it;

	  t = s;
	  tq = sq;
	  if (y != 0)
	    {
	      t += sumData[(y-1)*width+x];
	      tq += sqsumData[(y-1)*width+x];
	    }
	  sumData[y*width+x]=t;
	  sqsumData[y*width+x]=tq;
	}
    }
}

__global__ void
gpu_function_2(){
	  int y;
  int j;
  int x;
  int i;
  unsigned char* t;
  unsigned char* p;
  int w1 = src->width;
  int h1 = src->height;
  int w2 = dst->width;
  int h2 = dst->height;

  int rat = 0;

  unsigned char* src_data = src->data;
  unsigned char* dst_data = dst->data;


  int x_ratio = (int)((w1<<16)/w2) +1;
  int y_ratio = (int)((h1<<16)/h2) +1;

  for (i=0;i<h2;i++)
    {
      t = dst_data + i*w2;
      y = ((i*y_ratio)>>16);
      p = src_data + y*w1;
      rat = 0;
      for (j=0;j<w2;j++)
	{
	  x = (rat>>16);
	  *t++ = p[x];
	  rat += x_ratio;
	}
    }
}
