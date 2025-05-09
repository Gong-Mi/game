package com.yourvulkanapp; // 替换为你的包名

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView; // 如果你的布局有 TextView

public class MainActivity extends AppCompatActivity {

    // 加载你的原生库
    static {
        System.loadLibrary("native_vulkan_app"); // 替换为你在 CMakeLists.txt 中定义的库名称
    }

    // (可选) 声明你的原生函数，如果你想从 Java 调用 C++
    // public native String stringFromJNI();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 设置你的布局文件 (如果使用布局)
        // setContentView(R.layout.activity_main);

        // (可选) 调用原生函数并显示结果
        // TextView tv = findViewById(R.id.sample_text); // 假设布局中有 TextView
        // tv.setText(stringFromJNI());
    }
}
