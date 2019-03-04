
# coding: utf-8

# In[8]:


from tensorflow.python.client import device_lib

def get_available_gpus():
    local_device_protos = device_lib.list_local_devices()
    return [x.name for x in local_device_protos if x.device_type == 'GPU']
get_available_gpus()


# In[11]:


from tensorflow.python.client import device_lib

device_lib.list_local_devices()


# In[10]:


import tensorflow as tf
with tf.device('/gpu:0'):
    a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
    b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
    c = tf.matmul(a, b)

with tf.Session() as sess:
    print (sess.run(c))


# In[ ]:


get_ipython().system('pip uninstall tensorflow')
get_ipython().system('pip install tensorflow_gpu')
get_ipython().system('pip install tensorflow_hub')
get_ipython().system('pip install sklearn')
get_ipython().system('pip install bert-tensorflow')


# In[6]:


import pandas as pd
import tensorflow as tf
import tensorflow_hub as hub
from datetime import datetime
import bert
from bert import run_classifier
from bert import optimization
from bert import tokenization


# In[7]:


from tensorflow import keras
import os
import re


# In[ ]:


tf.test.gpu_device_name()

