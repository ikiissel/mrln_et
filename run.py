

import os
import subprocess
import time
import shutil


MERLIN_PATH = os.path.dirname(os.path.abspath(__file__))
TEMP_BASE = os.getenv('MERLIN_TEMP_DIR')
VOICE = os.getenv('MERLIN_VOICE')

def synthesize(text: str) -> bytes:
    
    #tempDir = str(time.time()).replace('.','')
    #tempDir = os.path.join(TEMP_BASE, tempDir)
    #os.mkdir(tempDir)
    tempDir = TEMP_BASE

    inPath = os.path.join(tempDir, 'in.txt')
    with open(inPath, 'w') as f:
        f.write(text)
        
    outPath = os.path.join(tempDir, 'out.wav')
    subprocess.run(
        [
            './web.sh',
            VOICE,
            inPath,
            outPath,
            str(tempDir)
        ],
        cwd=MERLIN_PATH,
        shell=False
    )
    with open(outPath, 'rb') as f:
        wav = f.read()

#    shutil.rmtree(tempDir)
    return wav

if __name__ == '__main__':
    audio = synthesize('Kas said enamvähem vastuse?')



