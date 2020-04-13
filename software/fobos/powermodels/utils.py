import numpy as np

def loadHypoPower(fileName):
    hypotheticalPower = []
    print(f'Loading hypothetical power from {fileName}')
    f = open(fileName, 'r+b')
    while True:
        try:
            hypoMatrixOneSubKey = np.load(f)
            # print(f'Hypo power matrix shape {hypoMatrixOneSubKey.shape}')
            hypotheticalPower.append(hypoMatrixOneSubKey)
        except ValueError:
            # print(e)
            # print(type(e))
            print('loading done.')
            break
        except Exception as e:
            print(e)

    return hypotheticalPower
    
def saveHypoPower(hypotheticalPower, fileName):
    print(f'Saving hypthetical power to {fileName}.')
    f = open(fileName, 'a+b')
    for h in hypotheticalPower:
        # print(h.shape)
        np.save(f, h)
    f.close()
    print('saving done.')
        