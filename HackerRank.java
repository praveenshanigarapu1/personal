//Palindrome Index

package com.hackerrank;

public class PalindromeIndex {
	
	static int palindromeIndex(String s) {
		int palindromIdex = -1;
		for (int i = 0; i < s.length(); i++) {
			if (s.charAt(i) != s.charAt(s.length() - i - 1)) {
				if (isPalidrom(s.substring(i + 1, s.length() - i))) {
					return i;
				} else {
					if (isPalidrom(s.substring(i, s.length() - i - 1))) {
						return s.length() - i - 1;
					}

				}

			}

		}

		return palindromIdex;
	}

	static boolean isPalidrom(String s) {
		StringBuffer sbPalindrome = new StringBuffer(s);
		String reverString = sbPalindrome.reverse().toString();
		return s.equals(reverString);
	}

	static boolean isPalidrom2(String s) {

		return true;
	}

	public static void main(String[] args) {
		System.out.println(palindromeIndex("aabccccaa"));
		System.out.println(palindromeIndex("aaccccbaa"));
		System.out.println(palindromeIndex("aba"));

		System.out.println(palindromeIndex("aaab"));
		System.out.println(palindromeIndex("baa"));
		System.out.println(palindromeIndex("aaa"));
	}

}
