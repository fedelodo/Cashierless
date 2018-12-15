clear all;
clearvars
status = system("azcopy --recursive --source https://elabdataset.blob.core.windows.net/thumbnails/ --destination ./images --source-key kJ6skRn9nnZGQUlz2lsrbTHDfkqjV8sm405uG+ou9QwDJBaP37qrScdtxGjGgc3eBs3boK1g2EuAxktRlPR1/A== --preserve-last-modified-time");
