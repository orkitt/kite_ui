# Kite 🪁

<p align="center">
A lightweight and fast <b>Flutter CLI</b> for creating projects, installing dependencies, and scaffolding clean architecture.
</p>

<p align="center">

![Pub Version](https://img.shields.io/pub/v/kite)
![Dart](https://img.shields.io/badge/Dart-CLI-blue)
![Flutter](https://img.shields.io/badge/Flutter-Developer%20Tool-02569B)
![License](https://img.shields.io/badge/License-MIT-green)

</p>

---

## 🚀 Overview

**Kite** is a developer-friendly **Flutter CLI tool** that simplifies common project setup tasks.

It helps Flutter developers quickly **bootstrap projects**, **install dependencies**, and **generate boilerplate code** using simple commands.

Instead of manually configuring folders, dependencies, and structure, Kite automates the workflow so you can focus on building features.

---

## ✨ Features

* 🚀 Quickly **create Flutter projects**
* 📦 Automatically **install dependencies**
* 🧪 Install **dev dependencies** with one command
* 🧱 Generate **clean architecture structure**
* ⚡ Fast and minimal **CLI workflow**
* 🧩 Generate **features, models, routes, and widgets**
* 🎯 Designed for **productivity and clean code**

Keywords: **flutter cli, scaffold, generator, boilerplate**

---

## 📦 Installation

Activate globally from pub.dev:

```bash
dart pub global activate kite
```

Then run:

```bash
kite
```

---

## 📌 Usage

### Create a Flutter Project

```bash
kite create my_app --org com.example
```

Create a project with **Riverpod architecture**:

```bash
kite create my_app --riverpod
```

---

### Generate Components

Generate project components using simple commands.

Create a feature:

```bash
kite feature auth --clean
```

Create a model:

```bash
kite model user
```

Create a route:

```bash
kite route login
```

Create a reusable widget:

```bash
kite widget primary_button
```

---

### Run the App

```bash
kite run
```

---

### Build the App

```bash
kite build
```

---

### Install Dev Dependencies

```bash
kite generate
```

This installs common development tools like:

* `build_runner`
* `json_serializable`
* `freezed`
* other dev utilities

---

## ⚡ Example Workflow

```bash
kite create shop_app --riverpod
cd shop_app

kite feature auth
kite model user
kite route login
kite widget primary_button

kite run
```

---

## 🎯 Goal

Kite aims to improve the **Flutter developer experience** by providing a fast and minimal CLI that automates repetitive setup tasks.

The goal is to make Flutter development **cleaner, faster, and more productive**.

---

## 🪁 Why Kite?

Flutter projects often require repetitive setup steps such as:

* creating folder structures
* installing dependencies
* generating boilerplate
* organizing features

**Kite automates these tasks**, allowing developers to start building features immediately.

---

## 📚 Future Plans

* More architecture generators
* Additional CLI commands
* Advanced project templates
* Custom scaffolding support

---

## ❤️ Contributing

Contributions, issues, and feature requests are welcome.

---

## 📄 License

MIT License

> Part of the Orkitt Flutter developer tools ecosystem.
---

<p align="center">

<b>Kite — Flutter projects that take off instantly.</b> 🪁
</p>

