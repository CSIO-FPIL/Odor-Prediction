import os
import numpy as np
from multiprocessing import Pool, cpu_count
import chmpy
from chmpy import Crystal,Molecule
##Input the directory path where your cif files are on line no 21
# and directory path for separate folder where the electron density csv files will be stored at line 15

def process_cif(filename):          
    f = os.path.join(directory, filename)
    c = Crystal.load(f)   
    surfaces = c.promolecule_density_isosurfaces(sep=0.2)
    surface = np.array(surfaces[0].vertices)      
    csv_filename = filename.replace('.cif', '.csv')
    csv_path = os.path.join('directory_where_electron_density_csv_files_will_be_stored', csv_filename)
    np.savetxt(csv_path, surface, delimiter=',')    
    return True
    
#Implementation of multiprocessing
if __name__ == "__main__":
    directory = 'file_path_where_cif_files_exist'
    file_list = os.listdir(directory)
    
    #  Pool of worker processes
    with Pool(processes=cpu_count()) as pool:
        # Process each CIF file in parallel
        results = pool.map(process_cif, file_list)
    
    # Check results for any errors
    if not all(results):
        print("Some files failed to process.")
