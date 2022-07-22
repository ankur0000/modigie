global with sharing class jwtapex {
    global static String get_access_token(String serviceAccCredential,String targetAud,String privateKey){
        try{
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            
            //Set endpoint for get token
            
            request.setEndpoint('https://www.googleapis.com/oauth2/v4/token');
            request.setMethod('POST');
            request.setHeader('ContentType','application/x-www-form-urlencoded');
            
            String header = '{"alg":"RS256","typ":"JWT"}';
            String header_encoded = EncodingUtil.base64Encode(blob.valueof(header));
            
            //String claim_set = '{"iss":"' + 'modigie-salesforce-app-3@modigie-beval-dev-2.iam.gserviceaccount.com' +'"';
            String claim_set = '{"iss":"' + serviceAccCredential +'"';
            claim_set += ',"target_audience":"' + targetAud + '"';
            //claim_set += ',"target_audience":"' + 'https://modigie-val-backend-pjcfvhz2qq-uc.a.run.app' + '"';
            //claim_set += ',"target_audience":"' + 'https://modigie-credits-backend-pjcfvhz2qq-uc.a.run.app' + '"';
            claim_set += ',"aud":"https://www.googleapis.com/oauth2/v4/token"';
            claim_set += ',"exp":' + datetime.now().addHours(1).getTime()/1000;
            claim_set += ',"iat": '+ datetime.now().getTime()/1000 + '}';
            
            String claim_set_encoded = EncodingUtil.base64Encode(Blob.valueof(claim_set));
            
            String signature_encoded = header_encoded + '.' + claim_set_encoded;
            
            //String ppr = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDgk/W99H8/Yg2K\nVgUvh6974DFhbpXhD1FKzMbTCCVEEBYP6LW39KVWdCFI2JrhyC129UzkT0JktVsv\nURAjG3n7ZZqO6Wzo0VtmPkYZ3TAuKi2XEKD8iHYr2Zndvvp/xDg2GCkZ5xjLhoml\nRWDzTKsFBhM8z6XV+jpgNyQBNmV4S1ED1jT2bXaujCQbq72FcmMmKbc7EDhx7XHu\nY1PAOSujxQyoun5sAU4YODOlwpflJRFCqE0kTPRQRD/qAew4k7o9lfHDRLtoSrA4\n9s48IE2kwilXkT51sukNclc2S/WsEWYf9RdSLmWJ15latN7HuTbtR5hUxaU7QLLj\nAwTimtB/AgMBAAECggEAEQHDc14noMIpKle3TtEkrendc3ZvbTq+uj5ltCeCwvPA\n5/WEhWjGeJSUzLJykDSblM2gxA1ohr3hKOUnprD2/N3F5Zqxv7PTCxweLOk+M9DH\n4Q/GUTl4UXvKFivXRoOyig4sVqTUkN0gYV6up94feWLrZAiJk3m+n/itBlZ7Oq+9\nF1NM2k1bTngDE3+FbY6/4RMCbVAVNZ2WUq0dVz+2GHpozz/ExVnQvz1b8f8rai4s\nnT9rHgoOxbUaQgYbGHBrITv0ehNDxkQ8On5kp1dTqKEvHF5TjQ7nvddhheMlsRGu\nZd04LHF/sfPJxmXjc3aFymCursELGW3vLVGwM1omWQKBgQD8FiVklPQStWqeuIP8\nEPLVrDPh5Bj/AykE9qBhBqmZjGKSISZQQ+9mgoN7nft3XtgABI1VWfjNc63YSikr\n58TfQPE4Q7tpZukTW640rnvO64atgH1Ayy0X6lrnTsSiKRwud/MFCmeKaUuxztJh\nMoSp8rwwcvheGUmlJPgGY8zXhQKBgQDkEHz3Fml40jjO0DhEARnPnP1xDFouxVT1\n9Ip3HcgI7QKSymYd5vGOz1E1TdHi6wJ9pURehHpiMVe8G9SRJFFuUniV576p34sP\nFIwPozRocUizuelwrGhfxggmcC+BGT9rXVZn0fsnFW53I+nSrK0iubvJTCA6ku1g\nai2UIbutMwKBgQCMa2Gk53wVt8yOYUXT8TTzZRr5Z2+tDXuZ8i9gHK/4gkSeFa0b\n5NvEBEttXpEm60PyrpZzxsxa1WcvJhBNDquRmMFFkCUjD1ohmF4vpkn89yFsIDil\nEQgrXDYKxsutcKzsDZDna+ZFKWYqw4RY9CUF7dp6OnCzKe7l+PPXy1vdaQKBgCws\nnWfmqWtDnMlCP4O8itlR2S1KbTVd94TkZuWHmTVRYww3s+vazbMRqPMgLaU8S/E2\nT7XXBzV5xTqkUVoDpNovkzfF+YJB0FeNbUuiGwaX2rMlMXgnjNfwLaf0Vt80mrob\nDB9z5qe9WPYuuJ2b4LU3MI5e9mciCmSAbG+i0Q1NAoGAByIBZljzPXk8TXnmx5FL\n6Hhz3kusBIxHiADwLui7iP4YsQeTotMWvt2IfqeXy0zlHMhy2tmI1CA8RM6PhZDH\nrU0hAU+h986wvNRfyYGVsVJYTDLITMWoSLpxsHR+RbML/UN2LdTWJR5zvSpxIqHF\nbFM9HlkquLsMVI2Qs8fbkQk=';
            //private key of service account
            //Blob private_key = EncodingUtil.base64Decode('MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDgk/W99H8/Yg2K\nVgUvh6974DFhbpXhD1FKzMbTCCVEEBYP6LW39KVWdCFI2JrhyC129UzkT0JktVsv\nURAjG3n7ZZqO6Wzo0VtmPkYZ3TAuKi2XEKD8iHYr2Zndvvp/xDg2GCkZ5xjLhoml\nRWDzTKsFBhM8z6XV+jpgNyQBNmV4S1ED1jT2bXaujCQbq72FcmMmKbc7EDhx7XHu\nY1PAOSujxQyoun5sAU4YODOlwpflJRFCqE0kTPRQRD/qAew4k7o9lfHDRLtoSrA4\n9s48IE2kwilXkT51sukNclc2S/WsEWYf9RdSLmWJ15latN7HuTbtR5hUxaU7QLLj\nAwTimtB/AgMBAAECggEAEQHDc14noMIpKle3TtEkrendc3ZvbTq+uj5ltCeCwvPA\n5/WEhWjGeJSUzLJykDSblM2gxA1ohr3hKOUnprD2/N3F5Zqxv7PTCxweLOk+M9DH\n4Q/GUTl4UXvKFivXRoOyig4sVqTUkN0gYV6up94feWLrZAiJk3m+n/itBlZ7Oq+9\nF1NM2k1bTngDE3+FbY6/4RMCbVAVNZ2WUq0dVz+2GHpozz/ExVnQvz1b8f8rai4s\nnT9rHgoOxbUaQgYbGHBrITv0ehNDxkQ8On5kp1dTqKEvHF5TjQ7nvddhheMlsRGu\nZd04LHF/sfPJxmXjc3aFymCursELGW3vLVGwM1omWQKBgQD8FiVklPQStWqeuIP8\nEPLVrDPh5Bj/AykE9qBhBqmZjGKSISZQQ+9mgoN7nft3XtgABI1VWfjNc63YSikr\n58TfQPE4Q7tpZukTW640rnvO64atgH1Ayy0X6lrnTsSiKRwud/MFCmeKaUuxztJh\nMoSp8rwwcvheGUmlJPgGY8zXhQKBgQDkEHz3Fml40jjO0DhEARnPnP1xDFouxVT1\n9Ip3HcgI7QKSymYd5vGOz1E1TdHi6wJ9pURehHpiMVe8G9SRJFFuUniV576p34sP\nFIwPozRocUizuelwrGhfxggmcC+BGT9rXVZn0fsnFW53I+nSrK0iubvJTCA6ku1g\nai2UIbutMwKBgQCMa2Gk53wVt8yOYUXT8TTzZRr5Z2+tDXuZ8i9gHK/4gkSeFa0b\n5NvEBEttXpEm60PyrpZzxsxa1WcvJhBNDquRmMFFkCUjD1ohmF4vpkn89yFsIDil\nEQgrXDYKxsutcKzsDZDna+ZFKWYqw4RY9CUF7dp6OnCzKe7l+PPXy1vdaQKBgCws\nnWfmqWtDnMlCP4O8itlR2S1KbTVd94TkZuWHmTVRYww3s+vazbMRqPMgLaU8S/E2\nT7XXBzV5xTqkUVoDpNovkzfF+YJB0FeNbUuiGwaX2rMlMXgnjNfwLaf0Vt80mrob\nDB9z5qe9WPYuuJ2b4LU3MI5e9mciCmSAbG+i0Q1NAoGAByIBZljzPXk8TXnmx5FL\n6Hhz3kusBIxHiADwLui7iP4YsQeTotMWvt2IfqeXy0zlHMhy2tmI1CA8RM6PhZDH\nrU0hAU+h986wvNRfyYGVsVJYTDLITMWoSLpxsHR+RbML/UN2LdTWJR5zvSpxIqHF\nbFM9HlkquLsMVI2Qs8fbkQk=');
			privateKey = privateKey.replace('\\n', '');
            Blob private_key = EncodingUtil.base64Decode(privateKey);
			
            signature_encoded = signature_encoded.replaceAll('=','');
            String signature_encoded_url = EncodingUtil.urlEncode(signature_encoded,'UTF-8');
            Blob signature_blob = Blob.valueof(signature_encoded_url);
            
            String signature_blob_string = EncodingUtil.base64Encode(Crypto.sign('RSA-SHA256', signature_blob, private_key));
            
            String JWT = signature_encoded + '.' + signature_blob_string;
            
            JWT = JWT.replaceAll('=','');
            String grant_string= 'urn:ietf:params:oauth:grant-type:jwt-bearer';
            request.setBody('grant_type=' + EncodingUtil.urlEncode(grant_string, 'UTF-8') + '&assertion=' + EncodingUtil.urlEncode(JWT, 'UTF-8'));
            response = h.send(request);
            //If status 200 then parse.
            if(response.getStatusCode() == 200) {
                JSONParser parser = JSON.createParser(response.getBody());
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'id_token')) {
                        // Move to the value.
                        parser.nextToken();
                        // Return the access_token
                        return parser.getText();
                    }
                }
            }
            else{
            	Map<String,Object> errorObj = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                Map <String,Object> errorMap = new Map<String,Object>(); 
                
                if(errorObj.get('error_description') != null){
                    errorMap.put('ErrorMessage', (String)errorObj.get('error_description'));
                    //throw new JwtapexException((String)errorObj.get('error_description'));
                }
                else{
                    errorMap.put('ErrorMessage', 'Google OAuth Server Error.');
                    //throw new JwtapexException('Google OAuth Server Error.');
                }

                errorMap.put('StatusCode', response.getStatusCode());
                errorMap.put('DisplayMessage', 'There seems to be a problem with your Modigie system credentials. Please contact your Modigie Administrator for assistance.');
                
                throw new ServerErrorException(JSON.serialize(errorMap));
            }
        	return 'Failed';
        }
        

        catch(ServerErrorException e){
            throw new ServerErrorException(e.getMessage());
        }
        catch(Exception e){
            //EmailServiceClass.sendEmail();
            //throw new JwtapexException('There seems to be a problem with your Modigie system credentials. Please contact your Modigie Administrator for assistance.');
            if(e.getMessage() == 'Invalid Crypto Key'){
                Map <String,Object> errorMap = new Map<String,Object>(); 
                errorMap.put('ErrorMessage', 'Invalid Private Key.');
                errorMap.put('DisplayMessage', 'There seems to be a problem with your Modigie system credentials. Please contact your Modigie Administrator for assistance.');
                throw new ServerErrorException(JSON.serialize(errorMap));
            }
            
            else{
               throw new JwtapexException(e.getMessage());
            }
        }
    }
    global class JwtapexException extends Exception{}
}