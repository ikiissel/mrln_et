# INSTALL

- välised sõltuvused
```sh
sudo apt-get update
sudo apt-get install build-essential csh realpath sox
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


