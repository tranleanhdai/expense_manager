buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Đặt thư mục build mới cho Flutter
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val subprojectBuild = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(subprojectBuild)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
