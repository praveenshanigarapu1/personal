//https://www.baeldung.com/java-common-array-operations 

<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.8.1</version>
</dependency>

the Arrays class provided by Java and the Apache's ArrayUtils one.

3. Get the First and Last Element of an Array

int[] array = new int[] { 3, 5, 2, 5, 14, 4 };
Knowing that the first item of an array is associated with the index value 0 and that it has a length attribute that we can use,
then it's simple to figure out how we can get these two elements:

int firstItem = array[0];
int lastItem = array[array.length - 1];

Get a Random Value from an Array
int anyValue = array[new Random().nextInt(array.length)];

5. Append a New Item to an Array

int[] newArray = Arrays.copyOf(array, array.length + 1);
newArray[newArray.length - 1] = newItem;

int[] newArray = ArrayUtils.add(array, newItem);

 Insert a Value Between Two Values
 
 int[] largerArray = ArrayUtils.insert(2, array, 77);
We have to specify the index in which we want to insert the value, and the output will be a new array containing a larger number of elements.

7. Compare Two Arrays

boolean areEqual = Arrays.equals(array1, array2);

Check if an Array Is Empty

1
boolean isEmpty = array == null || array.length == 0;
Moreover, we also have a null-safe method in the ArrayUtils helper class that we can use:

1
boolean isEmpty = ArrayUtils.isEmpty(array);

11. Remove Duplicates from an Array

// Box
Integer[] list = ArrayUtils.toObject(array);
// Remove duplicates
Set<Integer> set = new HashSet<Integer>(Arrays.asList(list));
// Create array and unbox
return ArrayUtils.toPrimitive(set.toArray(new Integer[set.size()]));


 Java 8's Streams
 
 String[] stringArray = Arrays.stream(array)
  .mapToObj(value -> String.format("Value: %s", value))
  .toArray(String[]::new);
  
  
  int[] evenArray = Arrays.stream(array)
  .filter(value -> value % 2 == 0)
  .toArray();


















































