# Merlinil põhinevad sünteeshääled

==============================================================================

      Merlin: The Neural Network (NN) based Speech Synthesis System
						https://github.com/CSTR-Edinburgh/merlin

==============================================================================

             Morfoloogiline analüsaator ja ühestaja                
                 Copyright (c) 2015, Filosoft                      
              https://github.com/Filosoft/vabamorf                 

==============================================================================
# INSTALL

- välised sõltuvused
```sh
sudo apt-get update
sudo apt-get install build-essential csh automake realpath sox
```

- anaconda3 installimine https://docs.anaconda.com/anaconda/install/linux/

- tööriistad
```sh
cd tools
./compile_tools.sh
```

- python
```sh
conda env create -f mrln_et.yml
conda activate mrln_et
```

- süntees
```sh
./synth.sh eki_et_tnu16k in.txt tnu.wav
```


