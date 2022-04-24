#!/bin/bash -e


current_working_dir=$(pwd)
merlin_dir=$current_working_dir

Voice=$1
inp_txt=$2
out_wav=$3

GGenLab=tools/genlab


dur_config_file=conf/dur_synth.conf
synth_config_file=conf/synth.conf


synthesis_dir=${current_working_dir}/voices/${Voice}/test_synthesis
gen_lab_dir=${synthesis_dir}/gen-lab
gen_wav_dir=${synthesis_dir}/wav

rm -f ${synthesis_dir}/prompt-lab/*.*
rm -f ${synthesis_dir}/gen-lab/*.*
rm -f ${synthesis_dir}/wav/*.*

SED=sed
$SED -i s#'Merlin:.*'#'Merlin: '$merlin_dir# $dur_config_file
$SED -i s#'TOPLEVEL:.*'#'TOPLEVEL: '${current_working_dir}# $dur_config_file
$SED -i s#'work:.*'#'work: %(TOPLEVEL)s/voices/'${Voice}'/duration_model'# $dur_config_file
$SED -i s#'label_align\s*:.*'#'label_align: %(TOPLEVEL)s/voices/'${Voice}'/test_synthesis/prompt-lab'# $dur_config_file
$SED -i s#'test_synth_dir\s*:.*'#'test_synth_dir: %(TOPLEVEL)s/voices/'${Voice}'/test_synthesis/gen-lab'# $dur_config_file
$SED -i s#'test_id_list\s*:.*'#'test_id_list: %(TOPLEVEL)s/voices/'${Voice}'/test_synthesis/test_id_list.scp'# $dur_config_file


$SED -i s#'Merlin\s*:.*'#'Merlin: '$merlin_dir# $synth_config_file
$SED -i s#'TOPLEVEL\s*:.*'#'TOPLEVEL: '${current_working_dir}# $synth_config_file
$SED -i s#'work\s*:.*'#'work: %(TOPLEVEL)s/voices/'${Voice}'/acoustic_model'# $synth_config_file
$SED -i s#'label_align\s*:.*'#'label_align: %(TOPLEVEL)s/voices/'${Voice}'/test_synthesis/gen-lab'# $synth_config_file
$SED -i s#'test_synth_dir\s*:.*'#'test_synth_dir: %(TOPLEVEL)s/voices/'${Voice}'/test_synthesis/wav'# $synth_config_file
$SED -i s#'test_id_list\s*:.*'#'test_id_list: %(TOPLEVEL)s/voices/'${Voice}'/test_synthesis/test_id_list.scp'# $synth_config_file


echo "preparing full-contextual labels"
mkdir -p ${current_working_dir}/voices/${Voice}/test_synthesis/prompt-lab
./${GGenLab}/bin/genlab -lex ${GGenLab}/dct/et.dct -lexd ${GGenLab}/dct/et3.dct -o ${current_working_dir}/voices/${Voice}/test_synthesis/ -f ${inp_txt}


echo "synthesizing durations..."
./submit.sh ${merlin_dir}/src/run_merlin.py $dur_config_file

echo "synthesizing speech..."
./submit.sh ${merlin_dir}/src/run_merlin.py $synth_config_file

echo "deleting intermediate synthesis files..."

shopt -s extglob

if [ -d "$gen_lab_dir" ]; then
    cd ${gen_lab_dir}
    rm -f *.!(lab)
fi

if [ -d "$gen_wav_dir" ]; then
    cd ${gen_wav_dir}
    rm -f weight
    rm -f *.!(wav)
fi

cd ${current_working_dir}
sox ${synthesis_dir}/wav/*.wav ${out_wav}
