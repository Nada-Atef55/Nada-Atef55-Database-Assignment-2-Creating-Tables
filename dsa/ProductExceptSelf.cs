public class Solution {
    public int[] ProductExceptSelf(int[] nums) {

        // time : O(n) , space : O(n + n)
        int n = nums.Length; 
        int[] suffix = new int[n];
        int[] prefix = new int[n];

        prefix[0] = nums[0];
        for(int i=1 ; i<n ; i++){
            prefix[i] = prefix[i-1] * nums[i];
        }

        suffix[n-1] = nums[n-1];
        for(int i=n-2 ; i>=0 ; i--){
            suffix[i] = suffix[i+1] * nums[i];
        }

        int[] result = new int[n];
        result[0] = suffix[1];
        result[n-1] = prefix[n-2];
        for(int i=1 ; i<n-1 ; i++){
            result[i] = prefix[i-1] * suffix[i+1];
        }

        return result;
    }
}



public class Solution {
    public int[] ProductExceptSelf(int[] nums) {
        // time : O(n) , space : O(1)
        int n = nums.Length; 
        int[] result = new int[n];

        int productOfAll = 1, zeros = 0, zeroIndex = 0;
        for(int i=0 ; i<n ; i++){
            if(nums[i] == 0){
                zeros++;
                zeroIndex = i;
                continue;
            }
            productOfAll *= nums[i];
        }
        if(zeros > 1){
            return result;
        } 
        if(zeros == 1){
            result[zeroIndex] = productOfAll;
            return result;
        }

        for(int i=0 ; i<n ; i++){
            result[i] = productOfAll/nums[i] ;
        }
        return result;
    }
}