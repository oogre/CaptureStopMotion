import java.io.FileFilter;
import java.util.*;

ArrayList<File> getPicturesAt() {
  ArrayList<File> fileList = new ArrayList<File>();
  FileFilter fileFilter = new FileFilter() {
    @Override
      public boolean accept(File pathname) {
      String name = pathname.getName().toLowerCase();
      return name.endsWith("jpg") || name.endsWith("jpeg") || name.endsWith("png");
    }
  };
  File root = new File(DATA_PATH);
  
  File[] list = root.listFiles(fileFilter);
  
  if (list == null) return fileList;
  for ( File f : list ) {
    fileList.add(f.getAbsoluteFile());
  }
  Collections.sort(fileList, new SortFileName());
  return fileList;
}

int countPicture(){
  ArrayList<File> fileList = new ArrayList<File>();
  FileFilter fileFilter = new FileFilter() {
    @Override
      public boolean accept(File pathname) {
      String name = pathname.getName().toLowerCase();
      return name.endsWith("jpg") || name.endsWith("jpeg") || name.endsWith("png");
    }
  };
  File root = new File(DATA_PATH);
  
  File[] list = root.listFiles(fileFilter);
  
  return list.length;
}

// creates the comparator for comparing stock value
class SortFileName implements Comparator<File> {

  // override the compare() method
  public int compare(File s1, File s2)
  {
    int s1Id = parseInt(split(s1.getName(), ".")[0]);
    int s2Id = parseInt(split(s2.getName(), ".")[0]);
    
    if (s1Id == s2Id)
      return 0;
    else if (s1Id > s2Id)
      return -1;
    else
      return 1;
  }
}


String getNextFrameName() {
  return DATA_PATH+"/"+nf(countPicture(), 3)+".jpg";
}

public PImage loadLastFrame() {
  ArrayList<File> pictures = getPicturesAt();
  if (pictures.size()>0) {
    return loadImage(pictures.get(0).getAbsolutePath());
  } else {
    return null;
  }
}

public void deleteLastFrame() {
  ArrayList<File> pictures = getPicturesAt();
  if (pictures.size()>0) {
    pictures.get(0).delete();
  }
}
