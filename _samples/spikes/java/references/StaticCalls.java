public class StaticCalls{
	
	public static final String STR_IN_SCHEMA = "http://schemas.com/sample.xsd";

	public static void Main(){
		SomeClass.someStaticMethod();
		System.out.println(STR_IN_SCHEMA);
		// todo: static import + out.println (do ineho sampla)
	}
}