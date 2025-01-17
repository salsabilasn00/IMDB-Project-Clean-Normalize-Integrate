# !/usr/bin/env python
# coding: utf-8

# In[1]:


import os

input_file = "D:\\dir to your source file\\file_imdb.tsv" 
output_dir = "D:\\dir to your output file\\file_imdb.tsv"
split_size = 1000000  # count of lines you want to 
part = 1
lines = list()

with open(input_file, 'r', encoding='utf-8') as file:
    for line_number, line in enumerate(file):
        lines.append(line)
        
        if (line_number + 1) % split_size == 0:
            output_file = os.path.join(output_dir, f"title_ratings_{part}.tsv")
            with open(output_file, 'w', encoding='utf-8') as output:
                output.writelines(lines)
            part += 1
            lines = list()  # Reset list for the next split batch

    # write the remaining rows 
    if lines:
        output_file = os.path.join(output_dir, f"title_ratings_{part}.tsv")
        with open(output_file, 'w', encoding='utf-8') as output:
            output.writelines(lines)

print("file splitted!")


# In[ ]:




