#!/bin/sh

# Copyright (c) Microsoft Corporation - All rights reserved
# Licensed under the MIT License

set -x
set -e

mkdir -p data
cd data

# echo "start to download Wikipedia dump"
# wget https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2

# echo "download completed, start to extract json files"
# python -m wikiextractor.WikiExtractor --json enwiki-latest-pages-articles.xml.bz2

# echo "extract completed, start to merge json files"
# ouput_json="wiki_all.json"

# find text/ -type f  -print0 |
#     while IFS= read -r -d '' line; do
#             filename=$(echo "$line" | rev | cut -d'/' -f 1 | rev)
#             subfilename=$(echo "$line" | rev | cut -d'/' -f 2 | rev)
#             prefix="${subfilename}_${filename}"
#             new_name=$(echo "$line")
#             echo "Procesing $prefix, $filename, $new_name"
#             cat $new_name >> $ouput_json
#     done

echo "start to preprocess"
# wget https://s3.amazonaws.com/models.huggingface.co/bert/gpt2-vocab.json
# wget https://s3.amazonaws.com/models.huggingface.co/bert/gpt2-merges.txt

## HF 토크나이저 쓰도록 수정됨 ##
# Copy from Megatron-DeepSpeed/tools/preprocess_data.py, edited with HF AutoTokenizer.
# python ../../third_party/Megatron-DeepSpeed/tools/preprocess_data.py \
python ../preprocess_data.py \
       --input "/home/datadriven/jb.lee/falcon_korean_stack_hq_w_trans.jsonl" \
       --output-prefix falcon_ko \
       --vocab 'beomi/llama-2-koen-13b' \
       --dataset-impl mmap \
       --tokenizer-type GPT2BPETokenizer \
       --merge-file gpt2-merges.txt \
       --append-eod \
       --workers 70

echo "preprocess completed, start to remove temporary files"

# rm -rf enwiki-latest-pages-articles.xml.bz2
# rm -rf text/
# rm -rf $ouput_json

cd ../
