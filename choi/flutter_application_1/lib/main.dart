import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// User 클래스 정의
class User {
  final String title;
  final String content;
  final String? insertImage;

  User({
    required this.title,
    required this.content,
    this.insertImage,
  });
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  User? _save;
  bool _titleHasFocus = false;
  bool _contentHasFocus = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();;
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    setState(() {
      _save = User(
        title: _titleController.text,
        content: _contentController.text,
        insertImage: null, // insertImage는 현재 null로 설정
      );
    });

    // 저장된 User 객체의 내용을 출력
    if (_save != null) {
      print('Title: ${_save!.title}');
      print('Content: ${_save!.content}');
    }

    // Server에 GET 요청
    String serverUrl = "http://minme.kro.kr:20000";
    // final res = await http.get(Uri.parse(serverUrl+"/"));
    // print(res.body);
    await http.post(Uri.parse(serverUrl+"/asd"), headers: {
      'Content-Type': 'application/json',
    }, body: jsonEncode({
      "title": _save!.title,
      "content": _save!.content
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('글 쓰기'),
        ),
        leading: IconButton(
          icon: Icon(Icons.close), // X 버튼 아이콘
          onPressed: () {
            Navigator.of(context).pop(); // 현재 페이지를 닫고 이전 페이지로 돌아감
          },
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: _handleSave, // 버튼 클릭 시 _handleSave 메서드를 호출
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 238, 16, 0), // 버튼 배경색
              foregroundColor: Colors.black, // 버튼 텍스트 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('완료'),
          ),
          SizedBox(width: 8), // 버튼과 오른쪽 가장자리 사이에 여백을 추가합니다.
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력 필드
            Stack(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: InputBorder.none, // 테두리 없애기
                    contentPadding: EdgeInsets.only(bottom: 8.0), // 내용과 선 사이의 여백
                  ),
                  maxLength: 100, // 제목의 최대 길이
                  onTap: () {
                    setState(() {
                      _titleHasFocus = true;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      _titleHasFocus = false;
                    });
                  },
                ),
                if (!_titleHasFocus && _titleController.text.isEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32, // Padding 고려
                      child: Text(
                        '제목',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32, // Padding 고려
                    height: 1,
                    color: const Color.fromARGB(255, 62, 61, 61), // 제목 아래 선 색상
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0), // 제목과 내용 사이의 여백
            // 내용 입력 필드
            Stack(
              children: [
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    border: InputBorder.none, // 테두리 없애기
                    contentPadding: EdgeInsets.only(bottom: 8.0), // 내용과 선 사이의 여백
                  ),
                  maxLines: 4, // 내용 입력 시 최대 라인 수
                  onTap: () {
                    setState(() {
                      _contentHasFocus = true;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      _contentHasFocus = false;
                    });
                  },
                ),
                if (!_contentHasFocus && _contentController.text.isEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32, // Padding 고려
                      child: Text(
                        '내용',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostPage(),
    ),
  );
}

